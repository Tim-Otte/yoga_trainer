import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:yoga_trainer/components/settings/tile.dart';
import 'package:yoga_trainer/components/settings/tile_type.dart';

class MaterialNumberSettingsTile extends MaterialSettingsTile {
  MaterialNumberSettingsTile({
    required super.prefix,
    required Widget super.title,
    super.description,
    required int value,
    required int min,
    required int max,
    required int step,
    required Function(int) onChanged,
    super.enabled = true,
    super.key,
  }) : super(
         tileType: SettingsTileType.numberTile,
         initialValue: value,
         suffix: Wrap(
           spacing: 10,
           children: [
             IconButton.filledTonal(
               onPressed: value > min ? () => onChanged(value - step) : null,
               icon: Icon(Symbols.remove),
             ),
             IconButton.filledTonal(
               onPressed: value < max ? () => onChanged(value + step) : null,
               icon: Icon(Symbols.add),
             ),
           ],
         ),
       );
}
