import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/details_list.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/components/stream_loader.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/add_pose.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/pages/pose_details.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

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
      onPressed: () {
        HapticFeedback.selectionClick();
        context.navigateTo(
          (_) => Provider(create: (_) => database, child: AddPosePage()),
        );
      },
    );
  }

  @override
  PageType getPageType() => PageType.normal;

  @override
  List<Tab> getTabs(BuildContext context) => [];

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return StreamLoader(
      stream: database.streamAllPoses(),
      noDataText: AppLocalizations.of(context).noPoses,
      builder: (context, poses) => SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(vertical: 20),
        child: Wrap(
          runSpacing: 20,
          children: [
            _getPoseGroup(
              context,
              Difficulty.easy,
              poses.where((x) => x.pose.difficulty == Difficulty.easy).toList(),
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
              poses.where((x) => x.pose.difficulty == Difficulty.hard).toList(),
            ),
          ],
        ),
      ),
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
    var settingsController = Provider.of<SettingsController>(context);
    final localizations = AppLocalizations.of(context);
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
              subtitle: DetailsList(
                children: [
                  DetailsListItem(
                    Symbols.person_search,
                    Text(bodyPart.name),
                    iconNeedsExtraSpace: true,
                  ),
                  DetailsListItem(
                    pose.isUnilateral ? Symbols.swap_horiz : Symbols.threesixty,
                    Text(
                      pose.isUnilateral
                          ? localizations.poseIsUnilateralLabelTrue
                          : localizations.poseIsUnilateralLabelFalse,
                    ),
                    iconNeedsExtraSpace: true,
                  ),
                  DetailsListItem(
                    Symbols.timer,
                    DurationText(Duration(seconds: pose.duration)),
                  ),
                ],
              ),
              leading: CircleAvatar(
                backgroundColor: pose.difficulty.getBackgroundColor(context),
                foregroundColor: pose.difficulty.getForegroundColor(context),
                child: Icon(pose.difficulty.getIcon()),
              ),
              onTap: () => context.navigateTo(
                (_) => MultiProvider(
                  providers: [
                    Provider(create: (_) => database),
                    ChangeNotifierProvider.value(value: settingsController),
                  ],
                  child: PoseDetailsPage(pose: pose, bodyPart: bodyPart),
                ),
                fullscreenDialog: true,
              ),
            );
          },
        ),
      ],
    );
  }
}
