import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class PlayWorkoutPage extends StatefulWidget {
  const PlayWorkoutPage({
    super.key,
    required this.workout,
    required this.poses,
  });

  final WorkoutWithInfos workout;
  final List<PoseWithBodyPartAndSide> poses;

  @override
  State<StatefulWidget> createState() => _PlayWorkoutPageState();
}

class _PlayWorkoutPageState extends State<PlayWorkoutPage> {
  int _currentPose = -1;
  int _totalTimerDuration = 0;
  int _timeExceededTotal = 0;
  int _timeRemainingInPose = 0;
  Side? _currentSide;
  IconData _currentPoseIcon = Symbols.sports_gymnastics;
  Timer? _timer;
  bool _workoutPaused = false;

  static const PREP_TIME = 3;

  final _timerNotifier = ValueNotifier<int>(0);

  double _timerFontSize = 85;
  Color _currentColor = Colors.red;
  final Random _random = Random();

  void _startTimer() {
    int total = 0;
    for (int i = 0; i < widget.poses.length; i++) {
      final item = widget.poses[i];

      total +=
          (item.pose.duration + PREP_TIME) *
          (item.pose.isUnilateral && item.side == Side.both ? 2 : 1);
    }

    setState(() {
      _totalTimerDuration = total;
      _timer = Timer.periodic(Duration(seconds: 1), _timerCallback);
    });
  }

  void _timerCallback(Timer timer) {
    if (_workoutPaused) return;

    setState(() {
      if (_timeExceededTotal < _totalTimerDuration) {
        _timeExceededTotal++;
        _timeRemainingInPose--;

        _timerFontSize = 100;
        _updatePoseData();
      } else {
        _currentColor = Color.fromARGB(
          255,
          _random.nextInt(256),
          _random.nextInt(256),
          _random.nextInt(256),
        );
      }
    });

    Future.delayed(
      Duration(milliseconds: 200),
      () => setState(() => _timerFontSize = 85),
    );
  }

  void _updatePoseData({bool? force}) {
    PoseWithBodyPartAndSide? current = _currentPose >= 0
        ? widget.poses[_currentPose]
        : null;

    if (force == true ||
        (_timeRemainingInPose <= 0 && _currentPose + 1 < widget.poses.length)) {
      if (current == null ||
          (current.side == Side.both && _currentSide == Side.right) ||
          current.side != Side.both) {
        _currentPose++;
        current = widget.poses[_currentPose];
      }

      // Pose is unilateral
      if (current.pose.isUnilateral) {
        // App will show both left and right pose
        if (current.side == Side.both) {
          // Left pose has already been trained
          if (_currentSide == Side.left) {
            _timeRemainingInPose = current.pose.duration + PREP_TIME;
            _currentSide = Side.right;
          }
          // Start with left pose
          else {
            _currentSide = Side.left;
            _timeRemainingInPose =
                widget.poses[_currentPose].pose.duration + PREP_TIME;
          }
        }
        // User has selected a custom side
        else {
          _currentSide = current.side;
          _timeRemainingInPose =
              widget.poses[_currentPose].pose.duration + PREP_TIME;
        }
      }
      // Pose trains whole body so no side has to be displayes
      else {
        _currentSide = null;
        _timeRemainingInPose =
            widget.poses[_currentPose].pose.duration + PREP_TIME;
      }
    }

    _currentPoseIcon = _getIcon(current!);

    if (_timeRemainingInPose > current.pose.duration) {
      _timerNotifier.value = _timeRemainingInPose - current.pose.duration;
    } else {
      _timerNotifier.value = _timeRemainingInPose;
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

  @override
  void initState() {
    super.initState();

    _updatePoseData(force: true);
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 15,
          children: [
            CircleAvatar(
              backgroundColor: widget.workout.difficulty.getBackgroundColor(
                context,
              ),
              foregroundColor: widget.workout.difficulty.getForegroundColor(
                context,
              ),
              child: Icon(widget.workout.difficulty.getIcon()),
            ),
            Text(widget.workout.workout.name),
          ],
        ),
        centerTitle: true,
        bottom: _timeExceededTotal < _totalTimerDuration
            ? PreferredSize(
                preferredSize: Size.fromHeight(6),
                child: LinearProgressIndicator(
                  value: _totalTimerDuration == 0
                      ? 0
                      : _timeExceededTotal.toDouble() /
                            _totalTimerDuration.toDouble(),
                ),
              )
            : null,
      ),
      body: _timeExceededTotal < _totalTimerDuration
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _currentPoseIcon,
                      size: 50,
                      color: theme.colorScheme.primary,
                    ),
                    Text(
                      widget.poses[_currentPose].pose.name,
                      style: theme.textTheme.displaySmall,
                    ),
                    Text(
                      widget.poses[_currentPose].pose.description,
                      style: theme.textTheme.bodyLarge,
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
            )
          : Center(
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
            ),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            SizedBox(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: _timeExceededTotal < _totalTimerDuration
          ? (_workoutPaused
                ? FloatingActionButton(
                    elevation: 0,
                    onPressed: () => setState(() => _workoutPaused = false),
                    child: Icon(Symbols.resume),
                  )
                : FloatingActionButton(
                    elevation: 0,
                    onPressed: () => setState(() => _workoutPaused = true),
                    child: Icon(Symbols.pause),
                  ))
          : FloatingActionButton(
              elevation: 0,
              onPressed: () => context.navigateBack(),
              child: Icon(Symbols.stop, fill: 1),
            ),
    );
  }

  @override
  void dispose() {
    if (_timer?.isActive ?? false) {
      _timer!.cancel();
    }

    super.dispose();
  }
}
