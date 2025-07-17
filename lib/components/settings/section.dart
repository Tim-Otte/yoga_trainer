import 'package:flutter/material.dart';

import 'tile.dart';

class MaterialSettingsSection extends StatelessWidget {
  const MaterialSettingsSection({
    super.key,
    required this.tiles,
    this.margin,
    this.title,
  });

  final List<MaterialSettingsTile> tiles;
  final EdgeInsets? margin;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return buildSectionBody(context);
  }

  Widget buildSectionBody(BuildContext context) {
    final tileList = buildTileList();

    if (title == null) {
      return Padding(padding: margin ?? EdgeInsets.zero, child: tileList);
    }

    final theme = Theme.of(context);
    final textScaler = MediaQuery.of(context).textScaler;

    return Padding(
      padding: (margin ?? EdgeInsets.zero).copyWith(
        bottom: textScaler.scale(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.only(
              bottom: textScaler.scale(10),
              start: 12,
              end: 24,
            ),
            child: DefaultTextStyle(
              style: theme.textTheme.titleMedium!,
              child: title!,
            ),
          ),
          Container(color: theme.colorScheme.surface, child: tileList),
        ],
      ),
    );
  }

  Widget buildTileList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: tiles.length,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) => tiles[index],
    );
  }
}
