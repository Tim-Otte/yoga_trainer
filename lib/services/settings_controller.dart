import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  int _workoutPrepTime = 3;
  int _posePrepTime = 3;
  Map<Object?, Object?> _ttsVoice = <Object?, Object?>{};
  double _ttsVolume = 1.0;
  double _ttsPitch = 1.0;
  double _ttsRate = 0.5;

  ThemeMode get themeMode => _themeMode;
  Locale? get locale =>
      _locale != null ? Locale.fromSubtags(languageCode: _locale!) : null;

  int get workoutPrepTime => _workoutPrepTime;
  int get posePrepTime => _posePrepTime;
  Map<Object?, Object?> get ttsVoice => _ttsVoice;
  double get ttsVolume => _ttsVolume;
  double get ttsPitch => _ttsPitch;
  double get ttsRate => _ttsRate;

  /// Load the user's settings from the SettingsService
  Future loadSettings() async {
    _themeMode = await _settingsService.getThemeMode();
    _locale = await _settingsService.getLocale();
    _posePrepTime = await _settingsService.getPosePrepTime();
    _workoutPrepTime = await _settingsService.getWorkoutPrepTime();
    _ttsVoice = await _settingsService.getTtsVoice();
    _ttsVolume = await _settingsService.getTtsVolume();
    _ttsPitch = await _settingsService.getTtsPitch();
    _ttsRate = await _settingsService.getTtsRate();

    if (_ttsVoice.isEmpty) {
      _ttsVoice = await (FlutterTts()).getDefaultVoice;
    }

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

  /// Update and persist the prep time for hard poses
  Future<void> updateWorkoutPrepTime(int value) async {
    if (value == _workoutPrepTime) return;

    _workoutPrepTime = value;
    notifyListeners();
    await _settingsService.updateWorkoutPrepTime(value);
  }

  /// Update and persist the default prep time for poses
  Future<void> updatePosePrepTime(int value) async {
    if (value == _posePrepTime) return;

    _posePrepTime = value;
    notifyListeners();
    await _settingsService.updatePosePrepTime(value);
  }

  /// Update and persist the TTS voice
  Future<void> updateTtsVoice(Map<Object?, Object?> value) async {
    if (value == _ttsVoice) return;

    _ttsVoice = value;
    notifyListeners();
    await _settingsService.updateTtsVoice(value);
  }

  /// Update and persist the TTS volume
  Future<void> updateTtsVolume(double value) async {
    if (value == _ttsVolume) return;

    _ttsVolume = value;
    notifyListeners();
    await _settingsService.updateTtsVolume(value);
  }

  /// Update and persist the TTS pitch
  Future<void> updateTtsPitch(double value) async {
    if (value == _ttsPitch) return;

    _ttsPitch = value;
    notifyListeners();
    await _settingsService.updateTtsPitch(value);
  }

  /// Update and persist the TTS rate
  Future<void> updateTtsRate(double value) async {
    if (value == _ttsRate) return;

    _ttsRate = value;
    notifyListeners();
    await _settingsService.updateTtsRate(value);
  }
}
