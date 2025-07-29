import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/components/stream_list_view.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/pages/workout_details.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class RecommendedWorkoutsPage extends StatelessWidget implements PageInfos {
  const RecommendedWorkoutsPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).recommendedWorkouts;
  }

  @override
  IconData getIcon() {
    return Symbols.star;
  }

  @override
  Widget? getFAB(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final database = Provider.of<AppDatabase>(context);
    final settingsController = Provider.of<SettingsController>(context);

    return StreamListView(
      stream: database.streamAllWorkouts(
        workoutPrepTime: settingsController.workoutPrepTime,
        defaultPosePrepTime: settingsController.posePrepTime,
        weekday: Weekday.values[DateTime.now().weekday - 1],
      ),
      noDataText: AppLocalizations.of(context).noRecommendedWorkouts,
      itemBuilder: (context, item, _) {
        final workout = item.workout;

        return ListTile(
          title: Text(workout.name),
          subtitle: Text(
            workout.description.isEmpty
                ? localizations.workoutDescriptionEmpty
                : workout.description,
            overflow: TextOverflow.ellipsis,
          ),
          leading: CircleAvatar(
            backgroundColor: item.difficulty.getBackgroundColor(context),
            foregroundColor: item.difficulty.getForegroundColor(context),
            child: Icon(item.difficulty.getIcon()),
          ),
          trailing: Chip(
            label: DurationText(
              Duration(minutes: (item.duration / 60.0).ceil()),
              prefixText: '~',
            ),
            avatar: Icon(Symbols.timer),
          ),
          onTap: () {
            context.navigateTo(
              (_) => MultiProvider(
                providers: [
                  Provider(create: (_) => database),
                  ChangeNotifierProvider.value(value: settingsController),
                ],
                child: WorkoutDetailsPage(workoutInfos: item),
              ),
            );
          },
        );
      },
    );
  }
}
