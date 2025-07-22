import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/add_or_edit_pose/all.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class AddPosePage extends StatefulWidget {
  const AddPosePage({super.key});

  @override
  State<StatefulWidget> createState() => _AddPosePageState();
}

class _AddPosePageState extends State<AddPosePage> {
  String _name = '';
  String _description = '';
  int _duration = 30;
  Difficulty _difficulty = Difficulty.medium;
  bool _isUnilateral = false;
  BodyPart? _affectedBodyPart;

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;

  @override
  Widget build(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed:
                _isFormValid && _name.isNotEmpty && _affectedBodyPart != null
                ? () async {
                    await database.insertPose(
                      _name,
                      _description,
                      _duration,
                      _difficulty,
                      _isUnilateral,
                      _affectedBodyPart!,
                    );

                    if (context.mounted) {
                      context.showSnackBar(localizations.snackbarPoseAdded);
                      context.navigateBack();
                    }
                  }
                : null,
            icon: Icon(Symbols.check),
          ),
          SizedBox(width: 10),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(localizations.addPose),
      ),
      body: SingleChildScrollView(
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
                initialValue: _difficulty,
                onChanged: (value) => setState(() {
                  _difficulty = value;
                }),
              ),
              NameInput(
                bodyPart: _affectedBodyPart,
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
              DurationInput(
                initialValue: _duration,
                onChanged: (value) => setState(() {
                  _duration = value;
                }),
              ),
              BodyPartsSelector(
                initialValue: _affectedBodyPart,
                onChanged: (value) {
                  setState(() => _affectedBodyPart = value);
                  _formKey.currentState?.validateGranularly();
                },
              ),
              IsUnilateralInput(
                initialValue: _isUnilateral,
                onChanged: (value) => setState(() {
                  _isUnilateral = value;
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
