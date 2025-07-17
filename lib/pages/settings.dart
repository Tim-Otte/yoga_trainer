import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/components/dialogs/all.dart';
import 'package:yoga_trainer/components/settings/all.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/page_infos.dart';
import 'package:yoga_trainer/services/settings_controller.dart';

class SettingsPage extends StatelessWidget implements PageInfos {
  const SettingsPage({super.key});

  @override
  String getTitle(BuildContext context) {
    return AppLocalizations.of(context).settings;
  }

  @override
  IconData getIcon() {
    return Symbols.settings;
  }

  @override
  Widget? getFAB(BuildContext context) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        children: [
          _getGeneralSettingsSection(context),
          _getPrepTimeSettingsSection(context),
        ],
      ),
    );
  }

  Widget _getGeneralSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    var localizations = AppLocalizations.of(context);

    return MaterialSettingsSection(
      title: Text(localizations.settingsGeneralSection),
      tiles: [
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.palette_rounded),
          title: Text(localizations.settingsTheme),
          value: Text(switch (settingsController.themeMode) {
            ThemeMode.system => localizations.themeModeSystem,
            ThemeMode.light => localizations.themeModeLight,
            ThemeMode.dark => localizations.themeModeDark,
          }),
          onTap: (context) async {
            var result = await showDialog<ThemeMode>(
              context: context,
              builder: (context) =>
                  ThemeModeDialog(currentValue: settingsController.themeMode),
            );
            settingsController.updateThemeMode(result);
          },
        ),
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.translate_rounded),
          title: Text(localizations.settingsLanguage),
          value: Text(
            LocaleNames.of(context)!.nameOf(
              settingsController.locale?.languageCode ??
                  Localizations.localeOf(context).languageCode,
            )!,
          ),
          onTap: (context) async {
            var result = await showDialog<String?>(
              context: context,
              builder: (context) => LanguageDialog(
                currentLocale:
                    settingsController.locale?.languageCode ??
                    localizations.localeName,
              ),
            );
            settingsController.updateLocale(result);
          },
        ),
      ],
    );
  }

  Widget _getPrepTimeSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    var localizations = AppLocalizations.of(context);
    var currentLang = Localizations.localeOf(context).languageCode;

    return MaterialSettingsSection(
      title: Text(localizations.settingsPrepTimeSection),
      tiles: [
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.sports_gymnastics),
          title: Text(localizations.settingsWorkoutPrepTime),
          value: settingsController.workoutPrepTime,
          description: Text(
            Duration(seconds: settingsController.workoutPrepTime).pretty(
              delimiter: ' ',
              locale: DurationLocale.fromLanguageCode(currentLang)!,
            ),
          ),
          min: 0,
          max: 10,
          onChanged: (value) => settingsController.updateWorkoutPrepTime(value),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.sentiment_very_satisfied),
          title: Text(localizations.settingsEasyPrepTime),
          value: settingsController.easyPrepTime,
          description: Text(
            Duration(seconds: settingsController.easyPrepTime).pretty(
              delimiter: ' ',
              locale: DurationLocale.fromLanguageCode(currentLang)!,
            ),
          ),
          min: 3,
          max: 10,
          onChanged: (value) => settingsController.updateEasyPrepTime(value),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.sentiment_calm),
          title: Text(localizations.settingsMediumPrepTime),
          value: settingsController.mediumPrepTime,
          description: Text(
            Duration(seconds: settingsController.mediumPrepTime).pretty(
              delimiter: ' ',
              locale: DurationLocale.fromLanguageCode(currentLang)!,
            ),
          ),
          min: 3,
          max: 10,
          onChanged: (value) => settingsController.updateMediumPrepTime(value),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.sentiment_frustrated),
          title: Text(localizations.settingsHardPrepTime),
          value: settingsController.hardPrepTime,
          description: Text(
            Duration(seconds: settingsController.hardPrepTime).pretty(
              delimiter: ' ',
              locale: DurationLocale.fromLanguageCode(currentLang)!,
            ),
          ),
          min: 3,
          max: 10,
          onChanged: (value) => settingsController.updateHardPrepTime(value),
        ),
      ],
    );
  }
}
