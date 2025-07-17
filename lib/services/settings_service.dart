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

  /// Loads the user's preferred prep time for easy poses
  Future<int> getEasyPrepTime() {
    return asyncPrefs.getInt('easyPrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred prep time for easy poses
  Future updateEasyPrepTime(int value) {
    return asyncPrefs.setInt('easyPrepTime', value);
  }

  /// Loads the user's preferred prep time for medium poses
  Future<int> getMediumPrepTime() {
    return asyncPrefs.getInt('mediumPrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred prep time for medium poses
  Future updateMediumPrepTime(int value) {
    return asyncPrefs.setInt('mediumPrepTime', value);
  }

  /// Loads the user's preferred prep time for hard poses
  Future<int> getHardPrepTime() {
    return asyncPrefs.getInt('hardPrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred prep time for hard poses
  Future updateHardPrepTime(int value) {
    return asyncPrefs.setInt('hardPrepTime', value);
  }

  /// Loads the user's preferred prep time for a workout
  Future<int> getWorkoutPrepTime() {
    return asyncPrefs.getInt('workoutPrepTime').then((value) => value ?? 3);
  }

  /// Saves the user's preferred prep time for a workout
  Future updateWorkoutPrepTime(int value) {
    return asyncPrefs.setInt('workoutPrepTime', value);
  }
}
