import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:yoga_trainer/components/dialogs/radio_dialog.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';

class LanguageDialog extends StatelessWidget {
  const LanguageDialog({super.key, required this.currentLocale});

  final String currentLocale;

  List<String> getNativeLocaleNames() {
    return LocaleNamesLocalizationsDelegate.nativeLocaleNames.entries
        .where(
          (code2name) => AppLocalizations.supportedLocales.any(
            (locale) => locale.languageCode == code2name.key,
          ),
        )
        .map((code2name) => code2name.key)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final nativeLocaleNames = getNativeLocaleNames();

    return RadioDialog<String>(
      title: localizations.settingsLanguage,
      values: nativeLocaleNames,
      initialValue: currentLocale,
      getTitle: (value) =>
          LocaleNamesLocalizationsDelegate.nativeLocaleNames[value]!,
    );
  }
}
