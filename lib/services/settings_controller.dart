import 'package:flutter/material.dart';
import 'package:yoga_trainer/services/settings_service.dart';

/// A class that many Widgets can interact with to read user settings, update
/// user settings, or listen to user settings changes.
///
/// Controllers glue Data Services to Flutter Widgets. The SettingsController
/// uses the SettingsService to store and retrieve user settings.
class SettingsController with ChangeNotifier {
  SettingsController(this._settingsService);

  final SettingsService _settingsService;

  ThemeMode _themeMode = ThemeMode.system;
  String? _locale;
  int _easyPrepTime = 3;
  int _mediumPrepTime = 3;
  int _hardPrepTime = 3;
  int _workoutPrepTime = 3;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale =>
      _locale != null ? Locale.fromSubtags(languageCode: _locale!) : null;

  int get easyPrepTime => _easyPrepTime;
  int get mediumPrepTime => _mediumPrepTime;
  int get hardPrepTime => _hardPrepTime;
  int get workoutPrepTime => _workoutPrepTime;

  /// Load the user's settings from the SettingsService
  Future loadSettings() async {
    _themeMode = await _settingsService.getThemeMode();
    _locale = await _settingsService.getLocale();
    _easyPrepTime = await _settingsService.getEasyPrepTime();
    _mediumPrepTime = await _settingsService.getMediumPrepTime();
    _hardPrepTime = await _settingsService.getHardPrepTime();
    _workoutPrepTime = await _settingsService.getWorkoutPrepTime();

    // Important! Inform listeners a change has occurred.
    notifyListeners();
  }

  /// Update and persist the ThemeMode
  Future updateThemeMode(ThemeMode? value) async {
    if (value == null || value == _themeMode) return;

    _themeMode = value;
    notifyListeners();
    await _settingsService.updateThemeMode(value);
  }

  /// Update and persist the locale
  Future<void> updateLocale(String? value) async {
    if (value == null || value == _locale) return;

    _locale = value;
    notifyListeners();
    await _settingsService.updateLocale(value);
  }

  /// Update and persist the prep time for easy poses
  Future<void> updateEasyPrepTime(int value) async {
    if (value == _easyPrepTime) return;

    _easyPrepTime = value;
    notifyListeners();
    await _settingsService.updateEasyPrepTime(value);
  }

  /// Update and persist the prep time for medium poses
  Future<void> updateMediumPrepTime(int value) async {
    if (value == _mediumPrepTime) return;

    _mediumPrepTime = value;
    notifyListeners();
    await _settingsService.updateMediumPrepTime(value);
  }

  /// Update and persist the prep time for hard poses
  Future<void> updateHardPrepTime(int value) async {
    if (value == _hardPrepTime) return;

    _hardPrepTime = value;
    notifyListeners();
    await _settingsService.updateHardPrepTime(value);
  }

  /// Update and persist the prep time for hard poses
  Future<void> updateWorkoutPrepTime(int value) async {
    if (value == _workoutPrepTime) return;

    _workoutPrepTime = value;
    notifyListeners();
    await _settingsService.updateWorkoutPrepTime(value);
  }
}
