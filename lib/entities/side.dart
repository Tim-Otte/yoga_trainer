import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

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

  String getTranslation(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return switch (this) {
      left => localizations.sideLeft,
      right => localizations.sideRight,
      both => localizations.sideBoth,
    };
  }
}
