import 'package:drift/drift.dart' show Value;
import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/add_or_edit_workout/all.dart';
import 'package:yoga_trainer/components/dialogs/confirm_delete.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/play_workout.dart';
import 'package:yoga_trainer/pages/select_poses_for_workout.dart';

class WorkoutDetailsPage extends StatefulWidget {
  const WorkoutDetailsPage({
    super.key,
    required this.workoutInfos,
    this.poseToAdd,
  });

  final WorkoutWithInfos workoutInfos;
  final PoseWithBodyPart? poseToAdd;

  @override
  State<WorkoutDetailsPage> createState() => _WorkoutDetailsPageState();
}

class _WorkoutDetailsPageState extends State<WorkoutDetailsPage> {
  late WorkoutsCompanion _workout;
  late WorkoutWithInfos _workoutInfos;
  List<PoseWithBodyPartAndSide>? _poses;
  bool _isInEditMode = false;
  bool _isFormValid = true;
  final _formKey = GlobalKey<FormState>();

  Side? _getSideForPose(
    List<PoseWithBodyPartAndSide> existingPoses,
    Pose pose,
  ) {
    if (pose.isUnilateral) {
      if (existingPoses.any((x) => x.side == Side.left) &&
          !existingPoses.any((x) => x.side == Side.right)) {
        return Side.right;
      } else if (!existingPoses.any((x) => x.side == Side.left) &&
          existingPoses.any((x) => x.side == Side.right)) {
        return Side.left;
      } else {
        return Side.both;
      }
    }

    return null;
  }

  @override
  void initState() {
    super.initState();

    _workoutInfos = widget.workoutInfos;
    _workout = widget.workoutInfos.workout.toCompanion(true);

    if (widget.poseToAdd != null) {
      _isInEditMode = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    if (_poses == null) {
      database.getAllPosesForWorkout(_workout.id.value).then((data) {
        if (widget.poseToAdd != null) {
          data.add(
            PoseWithBodyPartAndSide(
              pose: widget.poseToAdd!.pose,
              bodyPart: widget.poseToAdd!.bodyPart,
              side: _getSideForPose(data, widget.poseToAdd!.pose),
            ),
          );
        }
        setState(() => _poses = data);
      });
    }

    return PopScope(
      canPop: !_isInEditMode,
      onPopInvokedWithResult: (didPop, result) async {
        if (_isInEditMode && widget.poseToAdd == null) {
          var poses = await database.getAllPosesForWorkout(_workout.id.value);
          setState(() {
            _isInEditMode = false;
            _workout = _workoutInfos.workout.toCompanion(true);
            _poses = poses;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainer,
          title: Text(
            _isInEditMode ? localizations.editWorkout : _workout.name.value,
          ),
          actions: _isInEditMode
              ? [
                  IconButton(
                    onPressed: _isFormValid && (_poses ?? []).isNotEmpty
                        ? () async {
                            await database.updateWorkout(_workout, _poses!);
                            final updatedInfos = await database.getWorkout(
                              _workout.id.value,
                            );

                            if (widget.poseToAdd != null) {
                              if (context.mounted) {
                                context.navigateBack();
                              }
                            } else {
                              setState(() {
                                _isInEditMode = false;
                                _workoutInfos = updatedInfos;
                              });
                            }
                          }
                        : null,
                    icon: Icon(Symbols.check),
                  ),
                  SizedBox(width: 10),
                ]
              : null,
        ),
        body: SingleChildScrollView(
          child: _isInEditMode
              ? _getEditMode(context)
              : _getDisplayWidget(context),
        ),
        bottomNavigationBar: _isInEditMode
            ? BottomAppBar(color: theme.colorScheme.surface)
            : BottomAppBar(
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: () async {
                        var confirmed = await ConfirmDeleteDialog.show(context);

                        if (confirmed) {
                          await database.deleteWorkout(_workout.id.value);

                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        }
                      },
                      icon: Icon(Symbols.delete),
                      color: theme.colorScheme.error,
                      tooltip: localizations.delete,
                    ),
                    IconButton(
                      onPressed: () => setState(() => _isInEditMode = true),
                      icon: Icon(Symbols.edit),
                      tooltip: localizations.edit,
                    ),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
        floatingActionButton: _poses != null && _isInEditMode
            ? FloatingActionButton.extended(
                onPressed: () async {
                  final poses = await database.getAllPoses();

                  if (context.mounted) {
                    List<PoseWithBodyPart>? selectedWorkouts = await context
                        .navigateTo(
                          (_) => SelectPosesForWorkoutPage(poses: poses),
                        );

                    if (selectedWorkouts != null &&
                        selectedWorkouts.isNotEmpty) {
                      setState(
                        () => _poses!.addAll(
                          selectedWorkouts.map(
                            (item) => PoseWithBodyPartAndSide(
                              pose: item.pose,
                              bodyPart: item.bodyPart,
                              side: _getSideForPose(_poses!, item.pose),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
                label: Text(localizations.workoutAddPoses),
                icon: Icon(Symbols.forms_add_on),
                elevation: 0,
              )
            : FloatingActionButton(
                onPressed: () => context.navigateTo(
                  (_) => Provider(
                    create: (_) => database,
                    child: PlayWorkoutPage(
                      workout: _workoutInfos,
                      poses: _poses ?? [],
                    ),
                  ),
                ),
                elevation: 0,
                child: Icon(Symbols.play_arrow),
              ),
      ),
    );
  }

  Widget _getDisplayWidget(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.workoutDescription,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                _workout.description.value,
                style: theme.textTheme.bodyLarge,
              ),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: [
                  Chip(
                    label: Text(
                      _workoutInfos.difficulty.getTranslation(context),
                    ),
                    avatar: Icon(_workoutInfos.difficulty.getIcon()),
                  ),
                  Chip(
                    label: Text(
                      Duration(seconds: _workoutInfos.duration).pretty(
                        abbreviated: true,
                        delimiter: ' ',
                        locale: DurationLocale.fromLanguageCode(
                          Localizations.localeOf(context).languageCode,
                        )!,
                      ),
                    ),
                    avatar: Icon(Symbols.timer),
                  ),
                ],
              ),
              SizedBox(height: 35),
              ...(_poses == null
                  ? [Center(child: CircularProgressIndicator())]
                  : [
                      Text(
                        localizations.workoutPoses,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      _poses!.isNotEmpty
                          ? PoseList(poses: _poses!)
                          : Text(
                              localizations.workoutPosesEmpty,
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                    ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getEditMode(BuildContext context) {
    var localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () => setState(() {
          _isFormValid = _formKey.currentState?.validate() ?? false;
        }),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                localizations.workoutDetails,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            Wrap(
              runSpacing: 15,
              children: [
                NameInput(
                  initialValue: _workout.name.value,
                  onChanged: (value) => setState(() {
                    _workout = _workout.copyWith(name: Value(value));
                  }),
                ),
                DescriptionInput(
                  initialValue: _workout.description.value,
                  onChanged: (value) => setState(() {
                    _workout = _workout.copyWith(description: Value(value));
                  }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                localizations.workoutPoses,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            (_poses ?? []).isNotEmpty
                ? PoseList(
                    poses: _poses!,
                    onChanged: (value) => setState(() {
                      _poses = value;
                    }),
                  )
                : Text(
                    localizations.workoutPosesEmpty,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                  ),
          ],
        ),
      ),
    );
  }
}
