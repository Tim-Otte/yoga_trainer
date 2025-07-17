import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/components/settings/tile.dart';
import 'package:yoga_trainer/components/settings/tile_type.dart';

class MaterialNavigationSettingsTile extends MaterialSettingsTile {
  const MaterialNavigationSettingsTile({
    required super.prefix,
    required Widget super.title,
    super.description,
    required Function(BuildContext) super.onTap,
    super.enabled = true,
    super.key,
  }) : super(
         tileType: SettingsTileType.switchTile,
         suffix: const Padding(
           padding: EdgeInsets.symmetric(horizontal: 16),
           child: Icon(Symbols.chevron_right_rounded),
         ),
       );
}
