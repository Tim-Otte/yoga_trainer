import 'package:flutter/material.dart';

extension MenuControllerExtensions on MenuController {
  /// Toggles the menu that this [MenuController] is associated with.
  ///
  /// If [position] is given, then the menu will open at the position given,
  /// in the coordinate space of the root overlay.
  ///
  /// If the menu's anchor point is scrolled by an ancestor, or the view changes
  /// size, then any open menus will automatically close.
  void toggle({Offset? position}) {
    if (isOpen) {
      close();
    } else {
      open(position: position);
    }
  }
}
