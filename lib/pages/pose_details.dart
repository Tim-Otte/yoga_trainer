import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/add_or_edit_pose/all.dart';
import 'package:yoga_trainer/components/dialogs/confirm_delete.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/select_workout_to_update.dart';

class PoseDetailsPage extends StatefulWidget {
  const PoseDetailsPage({
    super.key,
    required this.pose,
    required this.bodyPart,
  });

  final Pose pose;
  final BodyPart bodyPart;

  @override
  State<PoseDetailsPage> createState() => _PoseDetailsPageState();
}

class _PoseDetailsPageState extends State<PoseDetailsPage> {
  late PosesCompanion _pose;
  late BodyPart _bodyPart;
  bool _isInEditMode = false;
  bool _isFormValid = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _pose = widget.pose.toCompanion(true);
    _bodyPart = widget.bodyPart;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return PopScope(
      canPop: !_isInEditMode,
      onPopInvokedWithResult: (didPop, result) async {
        if (_isInEditMode) {
          var data = await database.getPose(_pose.id.value);
          setState(() {
            _isInEditMode = false;
            _pose = data.pose.toCompanion(true);
            _bodyPart = data.bodyPart;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceContainer,
          title: Text(
            _isInEditMode ? localizations.editPose : _pose.name.value,
          ),
          actions: _isInEditMode
              ? [
                  IconButton(
                    onPressed: _isFormValid
                        ? () async {
                            await database.updatePose(_pose);

                            setState(() => _isInEditMode = false);
                          }
                        : null,
                    icon: Icon(Symbols.check),
                  ),
                  SizedBox(width: 10),
                ]
              : null,
        ),
        body: _isInEditMode
            ? _getEditMode(context)
            : _getDisplayWidget(context),
        bottomNavigationBar: _isInEditMode
            ? null
            : BottomAppBar(
                child: Wrap(
                  children: [
                    IconButton(
                      onPressed: () async {
                        var confirmed = await ConfirmDeleteDialog.show(context);

                        if (confirmed) {
                          await database.deletePose(widget.pose.id);

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
        floatingActionButton: _isInEditMode
            ? null
            : FloatingActionButton(
                onPressed: () async {
                  HapticFeedback.selectionClick();
                  var pose = await database.getPose(_pose.id.value);

                  if (context.mounted) {
                    context.navigateTo(
                      (_) => Provider(
                        create: (_) => database,
                        child: SelectWorkoutToUpdatePage(poseToAdd: pose),
                      ),
                    );
                  }
                },
                tooltip: localizations.addToWorkout,
                elevation: 0,
                child: Icon(Symbols.playlist_add),
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
                localizations.poseDescription,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(_pose.description.value, style: theme.textTheme.bodyLarge),
              SizedBox(height: 15),
              Wrap(
                spacing: 10,
                children: [
                  Chip(
                    label: Text(_pose.difficulty.value.getTranslation(context)),
                    avatar: Icon(_pose.difficulty.value.getIcon()),
                  ),
                  Chip(
                    label: Text(_bodyPart.name),
                    avatar: Icon(Symbols.person_search),
                  ),
                  Chip(
                    label: Text(
                      _pose.isUnilateral.value
                          ? localizations.poseIsUnilateralLabelTrue
                          : localizations.poseIsUnilateralLabelFalse,
                    ),
                    avatar: Icon(
                      _pose.isUnilateral.value
                          ? Symbols.swap_horiz
                          : Symbols.threesixty,
                    ),
                  ),
                  Chip(
                    label: Text('${_pose.duration.value}s'),
                    avatar: Icon(Symbols.timer),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getEditMode(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: () => setState(() {
          _isFormValid = _formKey.currentState?.validate() ?? false;
        }),
        child: Wrap(
          runSpacing: 15,
          children: [
            DifficultyInput(
              initialValue: _pose.difficulty.value,
              onChanged: (value) => setState(() {
                _pose = _pose.copyWith(difficulty: Value(value));
              }),
            ),
            NameInput(
              initialValue: _pose.name.value,
              onChanged: (value) => setState(() {
                _pose = _pose.copyWith(name: Value(value));
              }),
            ),
            DescriptionInput(
              initialValue: _pose.description.value,
              onChanged: (value) => setState(() {
                _pose = _pose.copyWith(description: Value(value));
              }),
            ),
            DurationInput(
              initialValue: _pose.duration.value,
              onChanged: (value) => setState(() {
                _pose = _pose.copyWith(duration: Value(value));
              }),
            ),
            BodyPartsSelector(
              initialValue: _bodyPart,
              onChanged: (value) => setState(() {
                _bodyPart = value;
                _pose = _pose.copyWith(affectedBodyPart: Value(value.id));
              }),
            ),
            IsUnilateralInput(
              initialValue: _pose.isUnilateral.value,
              onChanged: (value) => setState(() {
                _pose = _pose.copyWith(isUnilateral: Value(value));
              }),
            ),
          ],
        ),
      ),
    );
  }
}
