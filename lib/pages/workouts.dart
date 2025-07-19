import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/stream_list_view.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/add_workout.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/pages/workout_details.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class WorkoutsPage extends StatelessWidget implements PageInfos {
  const WorkoutsPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).workouts;
  }

  @override
  IconData getIcon() {
    return Symbols.self_improvement;
  }

  @override
  Widget? getFAB(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);
    var settingsController = Provider.of<SettingsController>(context);

    return FloatingActionButton(
      child: Icon(Symbols.add_2),
      onPressed: () {
        HapticFeedback.selectionClick();
        context.navigateTo(
          (_) => MultiProvider(
            providers: [
              Provider(create: (_) => database, child: AddWorkoutPage()),
              ChangeNotifierProvider.value(value: settingsController),
            ],
            child: AddWorkoutPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final database = Provider.of<AppDatabase>(context);
    final settingsController = Provider.of<SettingsController>(context);

    return StreamListView(
      stream: database.streamAllWorkouts(
        settingsController.workoutPrepTime,
        settingsController.posePrepTime,
      ),
      noDataText: AppLocalizations.of(context).noWorkouts,
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
            label: Text(
              Duration(minutes: (item.duration / 60.0).ceil()).pretty(
                abbreviated: true,
                delimiter: ' ',
                locale: DurationLocale.fromLanguageCode(
                  Localizations.localeOf(context).languageCode,
                )!,
              ),
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
