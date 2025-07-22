import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:yoga_trainer/constants.dart';
import 'package:yoga_trainer/database.dart';
import 'package:yoga_trainer/l10n/generated/app_localizations.dart';
import 'package:yoga_trainer/pages/layout.dart';
import 'package:yoga_trainer/services/settings_controller.dart';
import 'package:yoga_trainer/services/settings_service.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/google_fonts/NunitoSans-OFL.txt',
    );
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  WidgetsFlutterBinding.ensureInitialized();

  AwesomeNotifications().initialize('resource://drawable/self_improvement', [
    NotificationChannel(
      channelKey: Constants.dailyReminderChannelKey,
      channelName: 'Daily Yoga Reminder',
      channelDescription: 'Reminds you to do yoga every day',
      defaultColor: Color(0xFF2196F3),
      channelShowBadge: true,
    ),
  ], debug: true);

  var settingsController = SettingsController(SettingsService());

  settingsController.loadSettings();

  runApp(MyApp(settingsController: settingsController));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.settingsController});

  final SettingsController settingsController;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF2196F3),
        dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
      ),
    );
    final darkTheme = ThemeData.dark().copyWith(
      colorScheme: ColorScheme.fromSeed(
        brightness: Brightness.dark,
        seedColor: const Color(0xFF2196F3),
        dynamicSchemeVariant: DynamicSchemeVariant.tonalSpot,
      ),
    );

    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) => MaterialApp(
        localizationsDelegates: [
          ...AppLocalizations.localizationsDelegates,
          LocaleNamesLocalizationsDelegate(),
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: settingsController.locale,
        theme: lightTheme.copyWith(
          textTheme: GoogleFonts.nunitoSansTextTheme(lightTheme.textTheme),
        ),
        darkTheme: darkTheme.copyWith(
          textTheme: GoogleFonts.nunitoSansTextTheme(darkTheme.textTheme),
        ),
        themeMode: settingsController.themeMode,
        home: MultiProvider(
          providers: [
            Provider(
              create: (_) => AppDatabase(),
              dispose: (_, database) => database.close(),
            ),
            ChangeNotifierProvider.value(value: settingsController),
          ],
          builder: (context, child) => Layout(),
        ),
        onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
