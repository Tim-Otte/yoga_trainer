import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/icon_with_text.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/add_pose.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/pages/pose_details.dart';

class PosesPage extends StatelessWidget implements PageInfos {
  const PosesPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).poses;
  }

  @override
  IconData getIcon() {
    return Symbols.sports_gymnastics;
  }

  @override
  Widget? getFAB(BuildContext context) {
    var database = Provider.of<AppDatabase>(context);

    return FloatingActionButton(
      child: Icon(Symbols.add_2),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return Provider(create: (_) => database, child: AddPosePage());
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return StreamBuilder(
      stream: database.getAllPoses(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: IconWithText(
              icon: Symbols.dangerous,
              text: 'Error: ${snapshot.error}',
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: IconWithText(
              icon: Symbols.search_off,
              text: AppLocalizations.of(context).noPoses,
            ),
          );
        }

        final poses = snapshot.data!;

        return Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 20),
          child: Wrap(
            runSpacing: 20,
            children: [
              _getPoseGroup(
                context,
                Difficulty.easy,
                poses
                    .where((x) => x.pose.difficulty == Difficulty.easy)
                    .toList(),
              ),
              _getPoseGroup(
                context,
                Difficulty.medium,
                poses
                    .where((x) => x.pose.difficulty == Difficulty.medium)
                    .toList(),
              ),
              _getPoseGroup(
                context,
                Difficulty.hard,
                poses
                    .where((x) => x.pose.difficulty == Difficulty.hard)
                    .toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _getPoseGroup(
    BuildContext context,
    Difficulty difficulty,
    List<PoseWithBodyPart> poses,
  ) {
    if (poses.isEmpty) {
      return SizedBox();
    }

    var database = Provider.of<AppDatabase>(context);
    var localizations = AppLocalizations.of(context);
    var theme = Theme.of(context);

    String title = switch (difficulty) {
      Difficulty.easy => localizations.difficultyEasy,
      Difficulty.medium => localizations.difficultyMedium,
      Difficulty.hard => localizations.difficultyHard,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 15),
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
        ListView.builder(
          primary: false,
          shrinkWrap: true,
          itemCount: poses.length,
          itemBuilder: (context, index) {
            final pose = poses[index].pose;
            final bodyPart = poses[index].bodyPart;
            return ListTile(
              title: Text(pose.name),
              subtitle: Text(bodyPart.name),
              trailing: Chip(
                label: Text('${pose.duration}s'),
                avatar: Icon(Symbols.timer),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Provider(
                      create: (_) => database,
                      child: PoseDetailsPage(pose: pose, bodyPart: bodyPart),
                    ),
                    fullscreenDialog: true,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
