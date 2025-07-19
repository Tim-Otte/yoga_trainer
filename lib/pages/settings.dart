import 'package:duration/duration.dart';
import 'package:duration/locale.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
    return SingleChildScrollView(
      padding: EdgeInsetsGeometry.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        children: [
          _getGeneralSettingsSection(context),
          _getPrepTimeSettingsSection(context),
          _getTtsSettingsSection(context),
        ],
      ),
    );
  }

  Widget _getGeneralSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final localizations = AppLocalizations.of(context);

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
    final localizations = AppLocalizations.of(context);
    var currentLang = Localizations.localeOf(context).languageCode;

    return MaterialSettingsSection(
      title: Text(localizations.settingsPrepTimeSection),
      tiles: [
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.self_improvement),
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
          step: 1,
          onChanged: (value) => settingsController.updateWorkoutPrepTime(value),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.sports_gymnastics),
          title: Text(localizations.settingsPosePrepTime),
          value: settingsController.posePrepTime,
          description: Text(
            Duration(seconds: settingsController.posePrepTime).pretty(
              delimiter: ' ',
              locale: DurationLocale.fromLanguageCode(currentLang)!,
            ),
          ),
          min: 3,
          max: 60,
          step: 1,
          onChanged: (value) => settingsController.updatePosePrepTime(value),
        ),
      ],
    );
  }

  Widget _getTtsSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final localizations = AppLocalizations.of(context);
    var currentLang = Localizations.localeOf(context).languageCode;
    var flutterTts = FlutterTts();

    return MaterialSettingsSection(
      title: Text(localizations.settingsTtsSection),
      tiles: [
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.voice_selection),
          title: Text(localizations.settingsTtsVoice),
          value: Text(
            TtsVoiceDialog.getVoiceName(
              context,
              settingsController.ttsVoice['name'].toString(),
              settingsController.ttsVoice['network_required'] == '1',
            ),
          ),
          onTap: (context) async {
            var defaultVoice = await flutterTts.getDefaultVoice;
            var voices =
                ((await flutterTts.getVoices) as List<Object?>)
                    .where(
                      (x) => (x as Map<Object?, Object?>)['locale']
                          .toString()
                          .contains(currentLang),
                    )
                    .map((x) {
                      var m = x as Map<Object?, Object?>;
                      return {
                        'name': m['name'],
                        'locale': m['locale'],
                        'network_required': m['network_required'],
                      };
                    })
                    .toList()
                  ..sort(
                    (a, b) =>
                        a['name'].toString().compareTo(b['name'].toString()),
                  );

            if (context.mounted) {
              var result = await showDialog<String>(
                context: context,
                builder: (context) => TtsVoiceDialog(
                  voices: voices,
                  currentValue: settingsController.ttsVoice,
                ),
              );
              settingsController.updateTtsVoice(
                voices.where((x) => x['name'] == result).firstOrNull ??
                    defaultVoice,
              );
            }
          },
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.volume_up),
          title: Text(localizations.settingsTtsVolume),
          value: (settingsController.ttsVolume * 100).toInt(),
          description: Text('${(settingsController.ttsVolume * 100).toInt()}%'),
          min: 0,
          max: 100,
          step: 10,
          onChanged: (value) =>
              settingsController.updateTtsVolume(value / 100.0),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.edit_audio),
          title: Text(localizations.settingsTtsPitch),
          value: (settingsController.ttsPitch * 100).toInt(),
          description: Text('${(settingsController.ttsPitch * 100).toInt()}%'),
          min: 50,
          max: 200,
          step: 10,
          onChanged: (value) =>
              settingsController.updateTtsPitch(value / 100.0),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.speed),
          title: Text(localizations.settingsTtsRate),
          value: (settingsController.ttsRate * 100).toInt(),
          description: Text(
            '${((settingsController.ttsRate * 100) + 50).toInt()}%',
          ),
          min: 0,
          max: 100,
          step: 10,
          onChanged: (value) => settingsController.updateTtsRate(value / 100.0),
        ),
      ],
    );
  }
}
