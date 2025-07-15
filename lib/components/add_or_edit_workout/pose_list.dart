import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/entities/all.dart';

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

    final pose = item.pose;
    final bodyPart = item.bodyPart;
    final index = _poses.indexOf(item);

    return ListTile(
      key: ValueKey(item),
      contentPadding: EdgeInsets.symmetric(horizontal: 5),
      title: Text(pose.name),
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
          Icon(
            Symbols.person_search,
            size: 16,
            color: theme.colorScheme.primary,
          ),
          SizedBox(width: 4),
          Text(bodyPart.name),
          SizedBox(width: 10),
          Icon(Symbols.timer, size: 16, color: theme.colorScheme.primary),
          SizedBox(width: 4),
          Text('${pose.duration}s'),
        ],
      ),
      leading: CircleAvatar(child: Text('${index + 1}')),
      trailing: widget.onChanged != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...(item.side != null
                    ? [
                        IconButton(
                          onPressed: () => setState(() {
                            item.side = switch (item.side) {
                              Side.both => Side.right,
                              Side.right => Side.left,
                              Side.left => Side.both,
                              _ => Side.both,
                            };
                          }),
                          icon: Icon(item.side!.getIcon()),
                        ),
                      ]
                    : []),
                IconButton(
                  onPressed: () => setState(() {
                    _poses.removeAt(index);
                    widget.onChanged!(_poses);
                  }),
                  icon: Icon(Symbols.close),
                  color: theme.colorScheme.error,
                ),
              ],
            )
          : (item.side != null
                ? Icon(item.side!.getIcon(), color: theme.colorScheme.primary)
                : null),
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
