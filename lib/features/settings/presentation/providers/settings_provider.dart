import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _loadSettings();
  }

  static const _keyDefaultVolume = 'default_volume';
  static const _keyKeepScreenOn = 'keep_screen_on';
  static const _keyEnableBackgroundAudio = 'enable_background_audio';
  static const _keyThemeMode = 'theme_mode';

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    state = AppSettings(
      defaultVolume: prefs.getDouble(_keyDefaultVolume) ?? 0.8,
      keepScreenOn: prefs.getBool(_keyKeepScreenOn) ?? true,
      enableBackgroundAudio: prefs.getBool(_keyEnableBackgroundAudio) ?? true,
      themeMode: ThemeMode.values[prefs.getInt(_keyThemeMode) ?? 2],
    );
  }

  Future<void> setDefaultVolume(double volume) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyDefaultVolume, volume);
    state = state.copyWith(defaultVolume: volume);
  }

  Future<void> setKeepScreenOn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyKeepScreenOn, value);
    state = state.copyWith(keepScreenOn: value);
  }

  Future<void> setEnableBackgroundAudio(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyEnableBackgroundAudio, value);
    state = state.copyWith(enableBackgroundAudio: value);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyThemeMode, mode.index);
    state = state.copyWith(themeMode: mode);
  }
}
