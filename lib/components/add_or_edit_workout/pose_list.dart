import 'dart:ui';

import 'package:duration/duration.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/components/dialogs/number_dialog.dart';
import 'package:yoga_trainer/entities/all.dart';
import 'package:yoga_trainer/extensions/menu_controller.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class PoseList extends StatefulWidget {
  const PoseList({super.key, required this.poses, this.onChanged});

  final List<PoseWithBodyPartAndSide> poses;
  final Function(List<PoseWithBodyPartAndSide>)? onChanged;

  @override
  State<PoseList> createState() => _PoseListState();
}

class _PoseListState extends State<PoseList> {
  late List<PoseWithBodyPartAndSide> _poses;

  @override
  void initState() {
    super.initState();

    _poses = widget.poses;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onChanged != null) {
      return ReorderableListView(
        primary: false,
        shrinkWrap: true,
        proxyDecorator: _proxyDecorator,
        children: _poses.map((item) => _getListTile(context, item)).toList(),
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          setState(() {
            final movedPose = _poses.removeAt(oldIndex);
            _poses.insert(newIndex, movedPose);
            widget.onChanged!(_poses);
          });
        },
      );
    } else {
      return ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: _poses.length,
        itemBuilder: (context, index) {
          final item = _poses[index];
          return _getListTile(context, item);
        },
      );
    }
  }

  Widget _getListTile(BuildContext context, PoseWithBodyPartAndSide item) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    final pose = item.pose;
    final bodyPart = item.bodyPart;
    final index = _poses.indexOf(item);

    return ListTile(
      key: ValueKey(item),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: pose.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' (${bodyPart.name})',
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            pose.difficulty.getIcon(),
            size: 16,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 4),
          Text(pose.difficulty.getTranslation(context)),
          SizedBox(width: 10),
          Icon(Symbols.timer, size: 16, color: theme.colorScheme.primary),
          SizedBox(width: 4),
          Text(Duration(seconds: pose.duration).pretty(abbreviated: true)),
          SizedBox(width: 10),
          Icon(Symbols.hourglass, size: 16, color: theme.colorScheme.primary),
          SizedBox(width: 4),
          Text(Duration(seconds: item.prepTime).pretty(abbreviated: true)),
          SizedBox(width: 10),
          ...(pose.isUnilateral
              ? [
                  Icon(
                    item.side!.getIcon(),
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 4),
                  Text(item.side!.getTranslation(context)),
                ]
              : []),
        ],
      ),
      leading: CircleAvatar(child: Text('${index + 1}')),
      trailing: widget.onChanged != null
          ? MenuAnchor(
              alignmentOffset: Offset(-125, 0),
              menuChildren: [
                if (pose.isUnilateral)
                  MenuItemButton(
                    onPressed: () => setState(() {
                      item.side = switch (item.side) {
                        Side.both => Side.left,
                        Side.left => Side.right,
                        Side.right => Side.both,
                        _ => Side.both,
                      };
                      widget.onChanged!(_poses);
                    }),
                    leadingIcon: Icon(Symbols.arrow_range),
                    child: Text(localizations.editPoseSide),
                  ),
                MenuItemButton(
                  onPressed: () async {
                    var result = await showDialog(
                      context: context,
                      builder: (_) => NumberDialog(
                        title: localizations.editPosePrepTimeTitle,
                        description: localizations.editPosePrepTimeContent,
                        initialValue: item.prepTime,
                        min: 3,
                        max: 60,
                        unit: 's',
                      ),
                    );

                    if (result != null) {
                      setState(() => item.prepTime = result);
                      widget.onChanged!(_poses);
                    }
                  },
                  leadingIcon: Icon(Symbols.timer),
                  child: Text(localizations.editPosePrepTime),
                ),
                MenuItemButton(
                  style: MenuItemButton.styleFrom(
                    foregroundColor: theme.colorScheme.error,
                    iconColor: theme.colorScheme.error,
                  ),
                  onPressed: () => setState(() {
                    _poses.removeAt(index);
                    widget.onChanged!(_poses);
                  }),
                  leadingIcon: Icon(Symbols.delete),
                  child: Text(localizations.delete),
                ),
              ],
              builder: (context, controller, child) => IconButton(
                onPressed: () => controller.toggle(),
                icon: Icon(Symbols.more_vert),
              ),
            )
          : null,
    );
  }

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation) {
    var theme = Theme.of(context);

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 4, animValue)!;
        final Color? color = Color.lerp(
          theme.colorScheme.surfaceContainerHigh,
          theme.colorScheme.surfaceContainer,
          animValue,
        );
        return Material(
          elevation: elevation,
          color: color,
          borderRadius: BorderRadius.circular(10),
          child: child,
        );
      },
      child: child,
    );
  }
}
