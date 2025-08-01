import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:yoga_trainer/components/dialogs/all.dart';
import 'package:yoga_trainer/components/duration_text.dart';
import 'package:yoga_trainer/components/settings/all.dart';
import 'package:yoga_trainer/constants.dart';
import 'package:yoga_trainer/extensions/build_context.dart';
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
  PageType getPageType() => PageType.normal;

  @override
  List<Tab> getTabs(BuildContext context) => [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsGeometry.symmetric(vertical: 25, horizontal: 10),
      child: Column(
        children: [
          _getGeneralSettingsSection(context),
          _getNotificationSettingsSection(context),
          _getPrepTimeSettingsSection(context),
          _getTtsSettingsSection(context),
          _getAboutSection(context),
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

  Widget _getNotificationSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final localizations = AppLocalizations.of(context);
    final awesomeNotifications = AwesomeNotifications();

    return MaterialSettingsSection(
      title: Text(localizations.settingsNotificationSection),
      tiles: [
        MaterialSwitchSettingsTile(
          prefix: Icon(Symbols.notification_settings),
          title: Text(localizations.settingsEnableNotification),
          onToggle: (value) async {
            if (value) {
              const requiredPermissions = [
                NotificationPermission.Alert,
                NotificationPermission.Sound,
                NotificationPermission.Vibration,
                NotificationPermission.Badge,
              ];

              bool hasNotificationPermission = await awesomeNotifications
                  .isNotificationAllowed();

              if (hasNotificationPermission) {
                hasNotificationPermission =
                    (await awesomeNotifications.checkPermissionList(
                      permissions: requiredPermissions,
                    )).every(
                      (permission) => requiredPermissions.contains(permission),
                    );
              }

              if (!hasNotificationPermission) {
                hasNotificationPermission = await awesomeNotifications
                    .requestPermissionToSendNotifications(
                      permissions: requiredPermissions,
                    );
              }

              var preciseAlarmPermission = await awesomeNotifications
                  .checkPermissionList(
                    permissions: [NotificationPermission.PreciseAlarms],
                  );
              if (!preciseAlarmPermission.contains(
                NotificationPermission.PreciseAlarms,
              )) {
                await awesomeNotifications.showAlarmPage();
              }

              if (hasNotificationPermission && context.mounted) {
                _scheduleNotification(context);
              }

              return settingsController.updateNotificationState(
                hasNotificationPermission,
              );
            } else {
              // Cancel pending notifications when disabling notifications
              await awesomeNotifications.cancel(
                Constants.dailyReminderNotificationId,
              );

              if (context.mounted) {
                context.showSnackBar(
                  localizations.snackbarNotificationDisabled,
                );
              }
            }

            return settingsController.updateNotificationState(value);
          },
          value: settingsController.notificationState,
        ),
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.notification_add),
          title: Text(localizations.settingsNotificationTime),
          enabled: settingsController.notificationState,
          value: Text(
            localizations.settingsNotificationTimeValue(
              settingsController.notificationTime.format(context),
            ),
          ),
          onTap: (context) async {
            var result = await showTimePicker(
              context: context,
              initialTime: settingsController.notificationTime,
            );
            if (result != null) {
              settingsController.updateNotificationTime(result);

              if (context.mounted) {
                await _scheduleNotification(context);
              }
            }
          },
        ),
      ],
    );
  }

  Widget _getPrepTimeSettingsSection(BuildContext context) {
    final settingsController = Provider.of<SettingsController>(context);
    final localizations = AppLocalizations.of(context);

    return MaterialSettingsSection(
      title: Text(localizations.settingsPrepTimeSection),
      tiles: [
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.self_improvement),
          title: Text(localizations.settingsWorkoutPrepTime),
          value: settingsController.workoutPrepTime,
          description: DurationText(
            Duration(seconds: settingsController.workoutPrepTime),
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
          description: DurationText(
            Duration(seconds: settingsController.posePrepTime),
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
    var flutterTTS = FlutterTts();

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
          disableSuffixPadding: true,
          suffix: IconButton.filled(
            onPressed: () async {
              // Init TTS settings all at once
              await Future.wait([
                flutterTTS.setVoice({
                  'name': settingsController.ttsVoice['name'].toString(),
                  'locale': settingsController.ttsVoice['locale'].toString(),
                }),
                flutterTTS.setPitch(settingsController.ttsPitch),
                flutterTTS.setSpeechRate(settingsController.ttsRate),
                flutterTTS.awaitSpeakCompletion(true),
              ]);

              // Set volume to preferred volume
              VolumeController.instance.showSystemUI = false;
              var initialVolume = await VolumeController.instance.getVolume();
              await VolumeController.instance.setVolume(
                settingsController.ttsVolume,
              );

              // Say test phrase
              await flutterTTS.speak(localizations.ttsTestPhrase);

              // Reset volume to previous value
              await VolumeController.instance.setVolume(initialVolume);
            },
            icon: Icon(Symbols.play_arrow),
          ),
          onTap: (context) async {
            var defaultVoice = await flutterTTS.getDefaultVoice;
            var voices =
                ((await flutterTTS.getVoices) as List<Object?>)
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
          prefix: Icon(switch (settingsController.ttsVolume) {
            >= 0.66 => Symbols.volume_up,
            >= 0.33 => Symbols.volume_down,
            > 0 => Symbols.volume_mute,
            _ => Symbols.volume_off,
          }),
          title: Text(localizations.settingsTtsVolume),
          value: (settingsController.ttsVolume * 100).toInt(),
          description: Text('${(settingsController.ttsVolume * 100).toInt()}%'),
          min: 0,
          max: 100,
          step: 5,
          onChanged: (value) =>
              settingsController.updateTtsVolume(value / 100.0),
        ),
        MaterialNumberSettingsTile(
          prefix: Icon(Symbols.music_note),
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

  Widget _getAboutSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return MaterialSettingsSection(
      title: Text(localizations.settingsAboutSection),
      tiles: [
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.tag),
          title: Text(localizations.settingsAboutVersion),
          value: FutureBuilder(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) => Text(
              snapshot.hasData
                  ? '${snapshot.requireData.version}-${snapshot.requireData.buildNumber}'
                  : '',
            ),
          ),
        ),
        MaterialBasicSettingsTile(
          prefix: Icon(Symbols.favorite, color: theme.colorScheme.error),
          title: Text(localizations.settingsAboutLicenses),
          onTap: (context) => showLicensePage(context: context),
        ),
      ],
    );
  }

  Future _scheduleNotification(BuildContext context) async {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settingsController = Provider.of<SettingsController>(
      context,
      listen: false,
    );
    final awesomeNotifications = AwesomeNotifications();

    // Ensure we have the necessary permissions
    var hasNotificationPermission = await awesomeNotifications
        .isNotificationAllowed();

    if (!hasNotificationPermission) {
      if (context.mounted) {
        context.showSnackBar(
          localizations.snackbarNotificationMissingPermissions,
        );
      }
      return;
    }

    // Update the notification channel to use localized values
    awesomeNotifications.setChannel(
      NotificationChannel(
        channelKey: Constants.dailyReminderChannelKey,
        channelName: localizations.notificationChannelName,
        channelDescription: localizations.notificationChannelDescription,
        defaultColor: theme.colorScheme.primary,
        channelShowBadge: true,
        criticalAlerts: true,
      ),
    );

    // Calculate the datetime for the notification
    final now = DateTime.now();
    final scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      settingsController.notificationTime.hour,
      settingsController.notificationTime.minute,
    );

    // Remove any pending notifications with the same ID
    await awesomeNotifications.cancel(Constants.dailyReminderNotificationId);

    await awesomeNotifications.createNotification(
      content: NotificationContent(
        id: Constants.dailyReminderNotificationId,
        channelKey: Constants.dailyReminderChannelKey,
        title: localizations.notificationTitle,
        body: localizations.notificationBody,
        wakeUpScreen: true,
        category: NotificationCategory.Reminder,
        autoDismissible: false,
        criticalAlert: true,
      ),
      schedule: NotificationAndroidCrontab(
        timeZone: scheduledTime.isUtc
            ? AwesomeNotifications.utcTimeZoneIdentifier
            : AwesomeNotifications.localTimeZoneIdentifier,
        crontabExpression: CronHelper().daily(referenceDateTime: scheduledTime),
        repeats: false,
        allowWhileIdle: true,
        preciseAlarm: true,
      ),
    );

    var success = (await awesomeNotifications.listScheduledNotifications()).any(
      (x) => x.content?.id == Constants.dailyReminderNotificationId,
    );

    if (context.mounted) {
      if (success) {
        context.showSnackBar(localizations.snackbarNotificationScheduled);
      } else {
        context.showSnackBar(localizations.snackbarNotificationNotScheduled);
      }
    }
  }
}
