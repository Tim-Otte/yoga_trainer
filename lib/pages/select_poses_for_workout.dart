import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class SelectPosesForWorkoutPage extends StatefulWidget {
  const SelectPosesForWorkoutPage({super.key, required this.poses});

  final List<PoseWithBodyPart> poses;

  @override
  State<StatefulWidget> createState() => _SelectPosesForWorkoutPageState();
}

class _SelectPosesForWorkoutPageState extends State<SelectPosesForWorkoutPage> {
  final List<PoseWithBodyPart> _selected = [];

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final poses = widget.poses;

    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.selectPosesForWorkout),
        backgroundColor: theme.colorScheme.surfaceContainer,
        actions: [
          IconButton(
            onPressed: _selected.isNotEmpty
                ? () {
                    context.navigateBack(_selected);
                  }
                : null,
            icon: Icon(Symbols.check),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Padding(
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

    var theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.only(left: 15),
          child: Text(
            difficulty.getTranslation(context),
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
            final item = poses[index];
            final pose = item.pose;
            final bodyPart = item.bodyPart;

            return ListTile(
              title: Text(pose.name),
              subtitle: Row(
                children: [
                  Icon(
                    Symbols.person_search,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4),
                  Text(bodyPart.name),
                  SizedBox(width: 10),
                  Icon(
                    pose.isUnilateral ? Symbols.swap_horiz : Symbols.threesixty,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    pose.isUnilateral
                        ? localizations.poseIsUnilateralLabelTrue
                        : localizations.poseIsUnilateralLabelFalse,
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Symbols.timer,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4),
                  Text(
                    Duration(seconds: pose.duration).pretty(abbreviated: true),
                  ),
                ],
              ),
              leading: Checkbox(
                value: _selected.contains(item),
                onChanged: (checked) {
                  if ((checked ?? false)) {
                    if (!_selected.contains(item)) {
                      setState(() => _selected.add(item));
                    }
                  } else {
                    setState(() => _selected.remove(item));
                  }
                },
              ),
              onTap: () {
                if (_selected.contains(item)) {
                  setState(() => _selected.remove(item));
                } else {
                  setState(() => _selected.add(item));
                }
              },
            );
          },
        ),
      ],
    );
  }
}
