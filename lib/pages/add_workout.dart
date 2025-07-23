import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/add_or_edit_workout/all.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/select_poses_for_workout.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class AddWorkoutPage extends StatefulWidget {
  const AddWorkoutPage({super.key});

  @override
  State<StatefulWidget> createState() => _AddWorkoutPageState();
}

class _AddWorkoutPageState extends State<AddWorkoutPage> {
  String _name = '';
  String _description = '';
  List<PoseWithBodyPartAndSide> _poses = [];
  bool _isFormValid = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);
    var settingsController = Provider.of<SettingsController>(
      context,
      listen: false,
    );
    final localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _isFormValid && _poses.isNotEmpty
                ? () async {
                    await database.insertWorkout(_name, _description, _poses);

                    if (context.mounted) {
                      context.showSnackBar(localizations.snackbarWorkoutAdded);
                      context.navigateBack();
                    }
                  }
                : null,
            icon: Icon(Symbols.check),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: theme.colorScheme.surfaceContainer,
        title: Text(localizations.addWorkout),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                      initialValue: _name,
                      onChanged: (value) => setState(() {
                        _name = value;
                      }),
                    ),
                    DescriptionInput(
                      initialValue: _description,
                      onChanged: (value) => setState(() {
                        _description = value;
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
                _poses.isNotEmpty
                    ? ChangeNotifierProvider.value(
                        value: settingsController,
                        child: PoseList(
                          poses: _poses,
                          onChanged: (value) => setState(() {
                            _poses = value;
                          }),
                        ),
                      )
                    : Text(
                        localizations.workoutPosesEmpty,
                        style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(color: theme.colorScheme.surface),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final poses = await database.getAllPoses();

          if (context.mounted) {
            List<PoseWithBodyPart>? selectedWorkouts = await context.navigateTo(
              (_) => SelectPosesForWorkoutPage(poses: poses),
            );

            if (selectedWorkouts != null && selectedWorkouts.isNotEmpty) {
              setState(
                () => _poses.addAll(
                  selectedWorkouts.map((item) {
                    Side? side;

                    if (item.pose.isUnilateral) {
                      if (_poses.any((x) => x.side == Side.left) &&
                          !_poses.any((x) => x.side == Side.right)) {
                        side = Side.right;
                      } else if (!_poses.any((x) => x.side == Side.left) &&
                          _poses.any((x) => x.side == Side.right)) {
                        side = Side.left;
                      } else {
                        side = Side.both;
                      }
                    }

                    return PoseWithBodyPartAndSide(
                      pose: item.pose,
                      bodyPart: item.bodyPart,
                      side: side,
                      prepTime: null,
                    );
                  }),
                ),
              );
            }
          }
        },
        label: Text(localizations.workoutAddPoses),
        icon: Icon(Symbols.forms_add_on),
        elevation: 0,
      ),
    );
  }
}
