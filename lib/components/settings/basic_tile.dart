import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/settings/tile.dart';
import 'package:yoga_trainer/components/settings/tile_type.dart';

class MaterialBasicSettingsTile extends MaterialSettingsTile {
  MaterialBasicSettingsTile({
    super.key,
    required super.prefix,
    required Widget super.title,
    super.description,
    Widget? suffix,
    bool? disableSuffixPadding,
    super.value,
    super.onTap,
    super.enabled = true,
  }) : super(
         tileType: SettingsTileType.simpleTile,
         suffix: suffix != null
             ? (disableSuffixPadding ?? false)
                   ? suffix
                   : Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 16),
                       child: suffix,
                     )
             : null,
       );
}
