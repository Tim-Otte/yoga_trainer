import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/stream_list_view.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/workout_details.dart';

class SelectWorkoutToUpdatePage extends StatefulWidget {
  const SelectWorkoutToUpdatePage({super.key, required this.poseToAdd});

  final PoseWithBodyPart poseToAdd;

  @override
  State<SelectWorkoutToUpdatePage> createState() =>
      _SelectWorkoutToUpdatePageState();
}

class _SelectWorkoutToUpdatePageState extends State<SelectWorkoutToUpdatePage> {
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    var database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectWorkoutToUpdate),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: localizations.search,
                prefixIcon: Icon(Symbols.search),
              ),
              autofocus: true,
              initialValue: _searchText,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          Expanded(
            child: StreamListView(
              stream: database.streamAllWorkouts(search: _searchText),
              noDataText: AppLocalizations.of(context).noWorkouts,
              itemBuilder: (context, item, _) => ListTile(
                title: Text(item.workout.name),
                subtitle: Text(
                  item.workout.description,
                  overflow: TextOverflow.ellipsis,
                ),
                leading: CircleAvatar(child: Icon(item.difficulty.getIcon())),
                onTap: () => context.navigateTo(
                  (_) => Provider(
                    create: (_) => database,
                    child: WorkoutDetailsPage(
                      workoutInfos: item,
                      poseToAdd: widget.poseToAdd,
                    ),
                  ),
                  replace: true,
                  fullscreenDialog: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
