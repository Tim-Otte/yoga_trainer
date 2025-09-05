import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/workout_with_poses.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class SelectWorkoutsToImportPage extends StatefulWidget {
  const SelectWorkoutsToImportPage({super.key, required this.workouts});

  final List<WorkoutWithPoses> workouts;

  @override
  State<SelectWorkoutsToImportPage> createState() =>
      _SelectWorkoutsToImportPageState();
}

class _SelectWorkoutsToImportPageState
    extends State<SelectWorkoutsToImportPage> {
  final _selected = <int>[];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final database = Provider.of<AppDatabase>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectWorkoutsToImport),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: _selected.isEmpty
                ? null
                : () => context.navigateBack(
                    _selected.map((x) => widget.workouts[x]).toList(),
                  ),
            icon: Icon(Symbols.check),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.workouts.length,
        itemBuilder: (context, index) {
          final item = widget.workouts[index];

          return FutureBuilder(
            future: database.hasWorkoutWithName(item.name),
            builder: (context, snapshot) {
              final existsAlready = snapshot.hasData && snapshot.requireData;

              return CheckboxListTile(
                key: ValueKey(index),
                title: Text(
                  item.name,
                  style: TextStyle(
                    color: existsAlready ? theme.colorScheme.error : null,
                  ),
                ),
                subtitle: Text(
                  existsAlready
                      ? localizations.workoutExistsAlready
                      : (item.description.isEmpty
                            ? localizations.workoutDescriptionEmpty
                            : item.description),
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: existsAlready ? theme.colorScheme.error : null,
                  ),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                enabled: !existsAlready,
                value: _selected.contains(index),
                onChanged: (value) => setState(() {
                  if (value ?? false) {
                    if (!_selected.contains(index)) {
                      _selected.add(index);
                    }
                  } else {
                    _selected.remove(index);
                  }
                }),
              );
            },
          );
        },
      ),
    );
  }
}
