import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/page_infos.dart';

class WorkoutsPage extends StatelessWidget implements PageInfos {
  const WorkoutsPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).workouts;
  }

  @override
  IconData getIcon() {
    return Icons.self_improvement;
  }

  @override
  Widget? getFAB(BuildContext context) {
    return FloatingActionButton(child: Icon(Icons.add), onPressed: () {});
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: database.getAllWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: IconWithText(
              icon: Icons.dangerous,
              text: 'Error: ${snapshot.error}',
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: IconWithText(
              icon: Icons.search_off,
              text: AppLocalizations.of(context).noWorkouts,
            ),
          );
        }

        final workouts = snapshot.data!;

        return ListView.builder(
          itemCount: workouts.length,
          itemBuilder: (context, index) {
            final workout = workouts[index];
            return ListTile(
              title: Text(workout.name),
              subtitle: Text(workout.description),
              onTap: () {
                // Handle workout tap
              },
            );
          },
        );
      },
    );
  }
}
