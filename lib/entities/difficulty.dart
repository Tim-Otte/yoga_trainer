import 'package:flutter/widgets.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

enum Difficulty {
  easy,
  medium,
  hard;

  IconData getIcon() {
    return switch (this) {
      easy => Symbols.sentiment_very_satisfied,
      medium => Symbols.sentiment_calm,
      hard => Symbols.sentiment_frustrated,
    };
  }

  String getTranslation(BuildContext context) {
    var localization = AppLocalizations.of(context);

    return switch (this) {
      easy => localization.difficultyEasy,
      medium => localization.difficultyMedium,
      hard => localization.difficultyHard,
    };
  }
}
