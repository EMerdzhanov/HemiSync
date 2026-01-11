import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.defaultVolume = 0.8,
    this.keepScreenOn = true,
    this.enableBackgroundAudio = true,
    this.themeMode = ThemeMode.dark,
  });

  final double defaultVolume;
  final bool keepScreenOn;
  final bool enableBackgroundAudio;
  final ThemeMode themeMode;

  AppSettings copyWith({
    double? defaultVolume,
    bool? keepScreenOn,
    bool? enableBackgroundAudio,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      defaultVolume: defaultVolume ?? this.defaultVolume,
      keepScreenOn: keepScreenOn ?? this.keepScreenOn,
      enableBackgroundAudio:
          enableBackgroundAudio ?? this.enableBackgroundAudio,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object?> get props =>
      [defaultVolume, keepScreenOn, enableBackgroundAudio, themeMode];
}
