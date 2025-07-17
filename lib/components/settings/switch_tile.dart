import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/settings/tile.dart';
import 'package:yoga_trainer/components/settings/tile_type.dart';

class MaterialSwitchSettingsTile extends MaterialSettingsTile {
  MaterialSwitchSettingsTile({
    required super.prefix,
    required Widget super.title,
    super.description,
    Widget? suffix,
    required Function(bool) super.onToggle,
    required bool value,
    super.enabled = true,
    super.key,
  }) : super(
         tileType: SettingsTileType.switchTile,
         initialValue: value,
         suffix: suffix != null
             ? Row(
                 children: [
                   suffix,
                   Padding(
                     padding: const EdgeInsetsDirectional.only(end: 8),
                     child: Switch(
                       value: value,
                       onChanged: enabled ? onToggle : null,
                     ),
                   ),
                 ],
               )
             : Padding(
                 padding: const EdgeInsetsDirectional.only(start: 16, end: 8),
                 child: Switch(
                   value: value,
                   onChanged: enabled ? onToggle : null,
                 ),
               ),
       );
}
