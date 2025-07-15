import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';

enum Side {
  left,
  right,
  both;

  IconData getIcon() {
    return switch (this) {
      left => Symbols.arrow_back,
      right => Symbols.arrow_forward,
      both => Symbols.arrow_range,
    };
  }
}
