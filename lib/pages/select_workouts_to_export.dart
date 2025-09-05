import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/details_list.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/components/stream_list_view.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class SelectWorkoutsToExportPage extends StatefulWidget {
  const SelectWorkoutsToExportPage({super.key});

  @override
  State<SelectWorkoutsToExportPage> createState() =>
      _SelectWorkoutsToExportPageState();
}

class _SelectWorkoutsToExportPageState
    extends State<SelectWorkoutsToExportPage> {
  late final Stream<List<WorkoutWithInfos>> _stream;
  final _selected = <int>[];

  @override
  void initState() {
    super.initState();

    final database = Provider.of<AppDatabase>(context, listen: false);
    final settingsController = Provider.of<SettingsController>(
      context,
      listen: false,
    );

    _stream = database.streamAllWorkouts(
      workoutPrepTime: settingsController.workoutPrepTime,
      defaultPosePrepTime: settingsController.posePrepTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectWorkoutsToExport),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: _selected.isEmpty
                ? null
                : () => context.navigateBack(_selected),
            icon: Icon(Symbols.check),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamListView(
        stream: _stream,
        noDataText: AppLocalizations.of(context).noWorkouts,
        itemBuilder: (context, item, _) => CheckboxListTile(
          key: ValueKey(item.workout.id),
          title: Text(item.workout.name),
          subtitle: DetailsList(
            children: [
              DetailsListItem(
                item.difficulty.getIcon(),
                Text(item.difficulty.getTranslation(context)),
                iconNeedsExtraSpace: true,
              ),
              DetailsListItem(
                Symbols.timer,
                DurationText(Duration(seconds: item.duration)),
              ),
            ],
          ),
          controlAffinity: ListTileControlAffinity.leading,
          value: _selected.contains(item.workout.id),
          onChanged: (value) => setState(() {
            if (value ?? false) {
              if (!_selected.contains(item.workout.id)) {
                _selected.add(item.workout.id);
              }
            } else {
              _selected.remove(item.workout.id);
            }
          }),
        ),
      ),
    );
  }
}
