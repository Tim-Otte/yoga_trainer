import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:vibration/vibration.dart';
import 'package:vibration/vibration_presets.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class PlayWorkoutPage extends StatefulWidget {
  const PlayWorkoutPage({
    super.key,
    required this.settingsController,
    required this.workout,
    required this.poses,
  });

  final SettingsController settingsController;
  final WorkoutWithInfos workout;
  final List<PoseWithBodyPartAndSide> poses;

  @override
  State<StatefulWidget> createState() => _PlayWorkoutPageState();
}

class _PlayWorkoutPageState extends State<PlayWorkoutPage> {
  double _initialVolume = 0;
  int _currentPose = -1;
  int _totalTimerDuration = 0;
  int _timeExceededTotal = 0;
  int _timeRemainingInPose = 0;
  Side? _currentSide;
  IconData _currentPoseIcon = Symbols.hourglass;
  Timer? _timer;
  bool _workoutPaused = false;
  bool _stopIncreasingTimer = false;

  final _flutterTTS = FlutterTts();
  final _timerNotifier = ValueNotifier<int>(0);

  double _timerFontSize = 85;
  Color _currentColor = Colors.red;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _timerNotifier.value = widget.settingsController.workoutPrepTime;

    _init();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return PopScope(
      onPopInvokedWithResult: (_, _) async => Future.wait([
        WakelockPlus.disable(),
        VolumeController.instance.setVolume(_initialVolume),
      ]),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainer,
          title: Text(widget.workout.workout.name),
          centerTitle: true,
          automaticallyImplyLeading: _workoutPaused,
          bottom:
              _timeExceededTotal <= _totalTimerDuration &&
                  _timeExceededTotal > widget.settingsController.workoutPrepTime
              ? PreferredSize(
                  preferredSize: Size.fromHeight(6),
                  child: LinearProgressIndicator(
                    value: _totalTimerDuration == 0 ? 0 : _getProgress(),
                  ),
                )
              : null,
        ),
        body: _getBody(context),
        bottomNavigationBar: BottomAppBar(
          shape: AutomaticNotchedShape(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
          ),
          child: Row(
            children: [
              Card.filled(
                color: theme.colorScheme.surfaceContainerHighest,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 15,
                    children: [
                      Icon(Symbols.sports_gymnastics, size: 20),
                      Text(
                        '${_currentPose + 1} / ${widget.poses.length}',
                        style: theme.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: _timeExceededTotal < _totalTimerDuration
            ? FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  setState(() => _workoutPaused = !_workoutPaused);
                },
                child: Icon(_workoutPaused ? Symbols.resume : Symbols.pause),
              )
            : FloatingActionButton(
                elevation: 0,
                onPressed: () {
                  HapticFeedback.selectionClick();
                  context.navigateBack();
                },
                child: Icon(Symbols.exit_to_app, fill: 1),
              ),
      ),
    );
  }

  @override
  void activate() {
    super.activate();

    WakelockPlus.enable();
  }

  @override
  void deactivate() {
    WakelockPlus.disable();

    super.deactivate();
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }

    WakelockPlus.disable();

    super.dispose();
  }

  Future _init() async {
    // Prevent display from going to sleep
    await WakelockPlus.enable();

    // Init TTS settings all at once
    await Future.wait([
      _flutterTTS.setVoice({
        'name': widget.settingsController.ttsVoice['name'].toString(),
        'locale': widget.settingsController.ttsVoice['locale'].toString(),
      }),
      _flutterTTS.setPitch(widget.settingsController.ttsPitch),
      _flutterTTS.setSpeechRate(widget.settingsController.ttsRate),
      _flutterTTS.awaitSpeakCompletion(true),
    ]);

    // Set volume to preferred volume
    VolumeController.instance.showSystemUI = false;
    var volume = await VolumeController.instance.getVolume();
    setState(() => _initialVolume = volume);
    await VolumeController.instance.setVolume(
      widget.settingsController.ttsVolume,
    );

    _startTimer();
  }

  Widget _getBody(BuildContext context) {
    var theme = Theme.of(context);
    if (_timeExceededTotal <= widget.settingsController.workoutPrepTime) {
      if (widget.settingsController.workoutPrepTime > 0) {
        return Container(
          padding: EdgeInsets.all(40),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _currentPoseIcon,
                  size: 50,
                  color: theme.colorScheme.primary,
                ),
                SizedBox(height: 5),
                Text(
                  AppLocalizations.of(context).workoutPrepTime,
                  style: theme.textTheme.displaySmall,
                ),
                SizedBox(height: 50),
                SizedBox(
                  height: 130,
                  child: Center(
                    child: AnimatedDefaultTextStyle(
                      style: theme.textTheme.displayLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: _timerFontSize,
                      ),
                      duration: Duration(milliseconds: 300),
                      child: ValueListenableBuilder(
                        valueListenable: _timerNotifier,
                        builder: (context, timerData, _) =>
                            Text(timerData.toString()),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        return Center(child: CircularProgressIndicator());
      }
    } else if (_timeExceededTotal <= _totalTimerDuration) {
      return Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _currentPoseIcon,
                size: 50,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 5),
              Text(
                widget.poses[_currentPose].pose.name,
                style: theme.textTheme.displaySmall,
              ),
              Text(
                widget.poses[_currentPose].pose.description,
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 50),
              SizedBox(
                height: 130,
                child: Center(
                  child: AnimatedDefaultTextStyle(
                    style: theme.textTheme.displayLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: _timerFontSize,
                    ),
                    duration: Duration(milliseconds: 300),
                    child: ValueListenableBuilder(
                      valueListenable: _timerNotifier,
                      builder: (context, timerData, _) =>
                          Text(timerData.toString()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Symbols.celebration, size: 72, color: _currentColor),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context).finishedWorkout,
              style: theme.textTheme.displaySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }
  }

  double _getProgress() {
    return (_timeExceededTotal -
                (widget.settingsController.workoutPrepTime + 1))
            .toDouble() /
        (_totalTimerDuration - (widget.settingsController.workoutPrepTime + 1))
            .toDouble();
  }

  void _startTimer() {
    setState(() {
      _totalTimerDuration = widget.workout.duration;
      _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
    });
  }

  void _timerCallback(Timer timer) {
    if (_workoutPaused || _stopIncreasingTimer) return;

    if (mounted) {
      setState(() {
        if (_timeExceededTotal <= _totalTimerDuration) {
          _timeExceededTotal++;
          _timeRemainingInPose--;

          _timerFontSize = 100;
          _updatePoseData();
        } else {
          _currentColor =
              Colors.primaries[_random.nextInt(Colors.primaries.length)];
        }
      });
    }

    Future.delayed(Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() => _timerFontSize = 85);
      }
    });
  }

  void _updatePoseData() {
    PoseWithBodyPartAndSide? current = _currentPose >= 0
        ? widget.poses[_currentPose]
        : null;

    if (_timeExceededTotal > widget.settingsController.workoutPrepTime &&
        (_timeRemainingInPose <= 0 &&
            (_currentPose + 1 < widget.poses.length ||
                (current != null &&
                    current.pose.isUnilateral &&
                    current.side == Side.both &&
                    _currentSide == Side.left)))) {
      bool announcePose = false;
      int prepTimeToAnnounce = 0;

      if (
      // Start of the workout
      current == null ||
          // Pose is not unilateral
          !current.pose.isUnilateral ||
          // Pose is unilateral and training one side
          current.side != Side.both ||
          // Pose is unilateral, training both sides and the right is finished
          _currentSide == Side.right) {
        _currentPose++;
        current = widget.poses[_currentPose];
        prepTimeToAnnounce =
            current.prepTime ?? widget.settingsController.posePrepTime;

        announcePose = true;
      }

      // Pose is unilateral
      if (current.pose.isUnilateral) {
        // App will show both left and right pose
        if (current.side == Side.both) {
          // Left pose has already been trained
          if (_currentSide == Side.left) {
            _timeRemainingInPose =
                widget.poses[_currentPose].pose.duration +
                widget.settingsController.posePrepTime;
            _currentSide = Side.right;
            announcePose = true;
            prepTimeToAnnounce = widget.settingsController.posePrepTime;
          }
          // Start with left pose
          else {
            _currentSide = Side.left;
            _timeRemainingInPose =
                widget.poses[_currentPose].pose.duration +
                (current.prepTime ?? widget.settingsController.posePrepTime);
          }
        }
        // User has selected a custom side
        else {
          _currentSide = current.side;
          _timeRemainingInPose =
              widget.poses[_currentPose].pose.duration +
              (current.prepTime ?? widget.settingsController.posePrepTime);
        }
      }
      // Pose trains whole body so no side has to be displayes
      else {
        _currentSide = null;
        _timeRemainingInPose =
            current.pose.duration +
            (current.prepTime ?? widget.settingsController.posePrepTime);
      }

      if (announcePose) {
        if (_currentPose > 0) {
          Vibration.vibrate(preset: VibrationPreset.softPulse);
        }

        if (mounted) {
          _stopIncreasingTimer = true;

          final localizations = AppLocalizations.of(context);

          _flutterTTS
              .speak(
                current.pose.isUnilateral
                    ? localizations.ttsPoseWithSideAnnouncement(
                        current.pose.name,
                        _currentSide?.getTranslation(context) ?? '',
                        prepTimeToAnnounce,
                      )
                    : localizations.ttsPoseAnnouncement(
                        current.pose.name,
                        prepTimeToAnnounce,
                      ),
              )
              .then((_) {
                if (mounted) {
                  setState(() => _stopIncreasingTimer = false);
                }
              });
        }
      }
    }

    if (current != null) {
      _currentPoseIcon = _getIcon(current);

      if (_timeRemainingInPose > current.pose.duration) {
        _timerNotifier.value = _timeRemainingInPose - current.pose.duration;
      } else {
        _timerNotifier.value = _timeRemainingInPose;
      }
    } else {
      _timerNotifier.value =
          (widget.settingsController.workoutPrepTime + 1) - _timeExceededTotal;
    }

    if (!_stopIncreasingTimer) {
      // Its the workout prep time
      if (_timeExceededTotal <= widget.settingsController.workoutPrepTime) {
        _stopIncreasingTimer = true;
        _flutterTTS.speak(_timerNotifier.value.toString()).then((_) {
          if (mounted) {
            setState(() => _stopIncreasingTimer = false);
          }
        });
      }
      // Its the pose prep time
      else if (current != null &&
          _timeRemainingInPose - current.pose.duration <= 3 &&
          _timeRemainingInPose - current.pose.duration > 0) {
        _stopIncreasingTimer = true;
        _flutterTTS.speak(_timerNotifier.value.toString()).then((_) {
          if (mounted) {
            setState(() => _stopIncreasingTimer = false);
          }
        });
      }
      // Its the last 3 seconds of the pose
      else if (_timeRemainingInPose <= 3 && _timeRemainingInPose > 0) {
        _stopIncreasingTimer = true;
        _flutterTTS.speak(_timerNotifier.value.toString()).then((_) {
          if (mounted) {
            setState(() => _stopIncreasingTimer = false);
          }
        });
      }
    }

    if (_timeExceededTotal > 0 &&
        _timeExceededTotal >= _totalTimerDuration &&
        mounted) {
      Vibration.vibrate(preset: VibrationPreset.tripleBuzz);
      _flutterTTS.speak(AppLocalizations.of(context).ttsWorkoutFinished);
    }
  }

  IconData _getIcon(PoseWithBodyPartAndSide current) {
    if (_timeRemainingInPose > current.pose.duration) {
      return Symbols.hourglass;
    } else if (_currentSide != null) {
      return _currentSide!.getIcon();
    } else {
      return Symbols.sports_gymnastics;
    }
  }
}
