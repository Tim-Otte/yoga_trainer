import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/poses.dart';
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

  bool _poseWithNameAlreadyExists = false;

  @override
  Widget build(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.check)),
          SizedBox(width: 10),
        ],
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: Text(localizations.addPose),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Wrap(
            runSpacing: 20,
            children: [
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(localizations.poseName),
                  icon: Icon(Icons.label_outline),
                ),
                maxLength: 100,
                validator: (value) {
                  if (_poseWithNameAlreadyExists) {
                    return 'Already exists';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                initialValue: _name,
                onChanged: (value) async {
                  if (value.isNotEmpty) {
                    var nameCheck = await database.hasPoseWithName(value);
                    setState(() {
                      _poseWithNameAlreadyExists = nameCheck;
                      _name = value;
                    });
                  } else {
                    setState(() {
                      _poseWithNameAlreadyExists = false;
                      _name = value;
                    });
                  }
                },
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(localizations.poseDescription),
                  icon: Icon(Icons.info_outline),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                maxLength: 250,
                textInputAction: TextInputAction.next,
                initialValue: _description,
                onChanged: (value) => setState(() => _description = value),
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text(localizations.poseDuration),
                  icon: Icon(Icons.timer_outlined),
                  suffixText: localizations.poseDurationSuffix,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('^(60)|([1-5][0-9])|([1-9])\$'),
                  ),
                ],
                validator: (value) {
                  if (value == null) return null;

                  var parsed = int.tryParse(value);
                  if (parsed == null || parsed < 10 || parsed > 60) {
                    return localizations.poseDurationInvalid;
                  }

                  return null;
                },
                textInputAction: TextInputAction.next,
                initialValue: _duration.toString(),
                onChanged: (value) => setState(() {
                  var parsed = int.tryParse(value);
                  if (parsed != null) {
                    _duration = parsed;
                  }
                }),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  Text(
                    localizations.poseDifficulty,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SegmentedButton<Difficulty>(
                        segments: [
                          ButtonSegment(
                            value: Difficulty.easy,
                            icon: Icon(Icons.sentiment_very_satisfied),
                            label: Text(localizations.difficultyEasy),
                          ),
                          ButtonSegment(
                            value: Difficulty.medium,
                            icon: Icon(Icons.sentiment_neutral),
                            label: Text(localizations.difficultyMedium),
                          ),
                          ButtonSegment(
                            value: Difficulty.hard,
                            icon: Icon(Icons.sentiment_very_dissatisfied),
                            label: Text(localizations.difficultyHard),
                          ),
                        ],
                        selected: {_difficulty},
                        onSelectionChanged: (selected) => setState(() {
                          _difficulty = selected.first;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
