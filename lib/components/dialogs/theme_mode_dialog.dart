import 'package:flutter/material.dart';
import 'package:yoga_trainer/components/dialogs/radio_dialog.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({super.key, required this.currentValue});

  final ThemeMode currentValue;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return RadioDialog(
      title: localizations.settingsTheme,
      initialValue: currentValue,
      values: ThemeMode.values,
      getTitle: (value) => switch (value) {
        ThemeMode.system => localizations.themeModeSystem,
        ThemeMode.light => localizations.themeModeLight,
        ThemeMode.dark => localizations.themeModeDark,
      },
    );
  }
}
