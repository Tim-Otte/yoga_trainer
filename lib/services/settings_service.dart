import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A service that stores and retrieves user settings.
class SettingsService {
  final asyncPrefs = SharedPreferencesAsync();

  /// Loads the user's preferred ThemeMode.
  Future<ThemeMode> getThemeMode() {
    return asyncPrefs
        .getInt('themeMode')
        .then(
          (value) => value != null ? ThemeMode.values[value] : ThemeMode.system,
        );
  }

  /// Saves the user's preferred ThemeMode.
  Future updateThemeMode(ThemeMode value) {
    return asyncPrefs.setInt('themeMode', value.index);
  }

  /// Loads the user's preferred locale.
  Future<String?> getLocale() {
    return asyncPrefs.getString('locale');
  }

  /// Saves the user's preferred locale.
  Future updateLocale(String value) {
    return asyncPrefs.setString('locale', value);
  }

  /// Loads the user's preferred prep time for a workout
  Future<int> getWorkoutPrepTime() {
    return asyncPrefs.getInt('workoutPrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred prep time for a workout
  Future updateWorkoutPrepTime(int value) {
    return asyncPrefs.setInt('workoutPrepTime', value);
  }

  /// Loads the user's preferred default prep time for poses
  Future<int> getPosePrepTime() {
    return asyncPrefs.getInt('posePrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred default prep time for poses
  Future updatePosePrepTime(int value) {
    return asyncPrefs.setInt('posePrepTime', value);
  }

  /// Loads the user's preferred tts voice
  Future<Map<Object?, Object?>> getTtsVoice() {
    return asyncPrefs.getString('ttsVoice').then((value) {
      if ((value ?? '').isEmpty) {
        return <Object?, Object?>{};
      } else {
        return jsonDecode(value!) as Map<Object?, Object?>;
      }
    });
  }

  /// Saves the user's preferred tts voice
  Future updateTtsVoice(Map<Object?, Object?> value) {
    return asyncPrefs.setString('ttsVoice', jsonEncode(value));
  }

  /// Loads the user's preferred tts volume
  Future<double> getTtsVolume() {
    return asyncPrefs.getDouble('ttsVolume').then((value) => value ?? 0.5);
  }

  /// Saves the user's preferred tts volume
  Future updateTtsVolume(double value) {
    return asyncPrefs.setDouble('ttsVolume', value);
  }

  /// Loads the user's preferred tts pitch
  Future<double> getTtsPitch() {
    return asyncPrefs.getDouble('ttsPitch').then((value) => value ?? 1.0);
  }

  /// Saves the user's preferred tts pitch
  Future updateTtsPitch(double value) {
    return asyncPrefs.setDouble('ttsPitch', value);
  }

  /// Loads the user's preferred tts rate
  Future<double> getTtsRate() {
    return asyncPrefs.getDouble('ttsRate').then((value) => value ?? 0.5);
  }

  /// Saves the user's preferred tts rate
  Future updateTtsRate(double value) {
    return asyncPrefs.setDouble('ttsRate', value);
  }
}
