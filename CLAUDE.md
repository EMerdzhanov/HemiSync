# HemiSync - Binaural Beats Generator

## Overview

HemiSync is a cross-platform Flutter application for generating binaural beats with independent left/right ear frequency control. Binaural beats are created when two slightly different frequencies are played in each ear, causing the brain to perceive a third "beat" frequency equal to the difference between the two.

## Tech Stack

- **Framework**: Flutter 3.x (Dart)
- **State Management**: Riverpod (`flutter_riverpod`)
- **Audio Engine**: flutter_soloud (SoLoud audio library)
- **Local Storage**: Hive (presets), SharedPreferences (settings)
- **Navigation**: go_router (configured but using basic Navigator currently)

## Supported Platforms

- macOS (DMG installer)
- Windows (Setup.exe installer)
- Android (APK)
- Web (GitHub Pages)
- iOS (requires Apple Developer account to distribute)

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # MaterialApp configuration
├── services/
│   └── audio_background_service.dart  # Audio session configuration
├── core/
│   ├── constants/
│   │   ├── app_colors.dart           # Color palette
│   │   ├── audio_constants.dart      # Frequency ranges, brainwave categories
│   │   └── built_in_presets.dart     # Default presets
│   ├── theme/
│   │   └── app_theme.dart            # Dark theme configuration
│   └── widgets/
│       ├── frequency_slider.dart     # Frequency control with +/- buttons
│       └── waveform_selector.dart    # Waveform type selector
└── features/
    ├── audio_engine/
    │   ├── data/
    │   │   └── audio_engine_impl.dart      # SoLoud implementation
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── audio_channel.dart      # Left/right channel model
    │   │   │   └── waveform_type.dart      # Sine, square, triangle, sawtooth
    │   │   └── repositories/
    │   │       └── audio_engine_repository.dart  # Abstract interface
    │   └── presentation/
    │       └── providers/
    │           └── audio_engine_provider.dart    # Riverpod providers
    ├── player/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── playback_state.dart     # Playing/paused/stopped state
    │   └── presentation/
    │       ├── screens/
    │       │   └── player_screen.dart      # Main player UI
    │       └── widgets/
    │           ├── play_pause_button.dart
    │           └── beat_info_display.dart  # Shows beat frequency
    ├── presets/
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   └── preset_local_datasource.dart  # Hive storage
    │   │   └── models/
    │   │       └── preset_model.dart       # Hive model with adapters
    │   ├── domain/
    │   │   └── entities/
    │   │       └── preset.dart             # Preset entity
    │   └── presentation/
    │       ├── providers/
    │       │   └── presets_provider.dart
    │       ├── screens/
    │       │   ├── presets_screen.dart
    │       │   └── create_preset_screen.dart
    │       └── widgets/
    │           └── preset_card.dart
    ├── timer/
    │   ├── domain/
    │   │   └── entities/
    │   │       └── session_timer.dart
    │   └── presentation/
    │       ├── providers/
    │       │   └── timer_provider.dart
    │       └── widgets/
    │           ├── timer_display.dart
    │           └── timer_picker.dart
    └── settings/
        ├── domain/
        │   └── entities/
        │       └── app_settings.dart
        └── presentation/
            ├── providers/
            │   └── settings_provider.dart
            └── screens/
                └── settings_screen.dart
```

## Key Concepts

### Binaural Beats

The difference between left and right ear frequencies creates the binaural beat:
- Left ear: 200 Hz, Right ear: 210 Hz → Beat frequency: 10 Hz (Alpha)

### Brainwave Categories

| Category | Frequency Range | Effect |
|----------|----------------|--------|
| Delta | 0.5 - 4 Hz | Deep sleep, healing |
| Theta | 4 - 8 Hz | Meditation, creativity |
| Alpha | 8 - 14 Hz | Relaxation, calm focus |
| Beta | 14 - 30 Hz | Focus, concentration |
| Gamma | 30 - 100 Hz | Peak awareness, insight |

### Waveform Types

- **Sine**: Pure tone (recommended for binaural beats)
- **Square**: Rich harmonics
- **Triangle**: Soft harmonics
- **Sawtooth**: Bright tone

## Audio Engine

The audio engine uses `flutter_soloud` for real-time waveform generation:

```dart
// Key methods in AudioEngineImpl
Future<void> initialize();           // Initialize SoLoud
Future<void> playBinauralBeat(left, right);  // Start playback
Future<void> stop();                 // Stop playback
void setLeftFrequency(double freq);  // Update left channel
void setRightFrequency(double freq); // Update right channel
void setVolume(double volume);       // Set master volume
void fadeVolume(target, duration);   // Smooth volume transition
```

### Stereo Panning

Each channel is panned to its respective ear:
```dart
_soloud!.setPanAbsolute(_leftHandle!, 1.0, 0.0);   // Left ear only
_soloud!.setPanAbsolute(_rightHandle!, 0.0, 1.0);  // Right ear only
```

## State Management

Using Riverpod with StateNotifier pattern:

```dart
// Main providers
final audioEngineRepositoryProvider = Provider<AudioEngineRepository>(...);
final playbackStateProvider = StateNotifierProvider<PlaybackStateNotifier, PlaybackState>(...);
final timerProvider = StateNotifierProvider<TimerNotifier, SessionTimer>(...);
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>(...);
final presetsProvider = StateNotifierProvider<PresetsNotifier, List<Preset>>(...);
```

## Color Scheme

```dart
// Primary dark theme
background: #0D1117
surface: #161B22
surfaceLight: #21262D

// Channel colors
leftChannel: #3B82F6 (blue)
rightChannel: #F472B6 (pink)

// Accent colors
primary: #58A6FF
secondary: #8B5CF6
accent: #22D3EE
```

## Running the App

```bash
# iOS Simulator
flutter run -d ios

# macOS
flutter run -d macos

# Android
flutter run -d android

# Web
flutter run -d chrome
```

## Building for Release

```bash
# iOS
flutter build ios

# macOS
flutter build macos

# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle
```

## Future Development Ideas

### Potential Features
- [ ] Isochronic tones (single pulsing tone)
- [ ] Pink/brown noise background layer
- [ ] Session history and statistics
- [ ] Export/import presets
- [ ] Haptic feedback sync with beat
- [ ] Apple Health / Google Fit integration
- [ ] Widget support (iOS/Android)
- [ ] Apple Watch companion app
- [ ] Visualization modes (animated waveforms)
- [ ] Guided meditation overlay
- [ ] Sleep timer with gradual fade-out
- [ ] Frequency sweep/ramp feature

### Technical Improvements
- [ ] Add unit tests for audio engine
- [ ] Add widget tests for UI components
- [ ] Implement proper error handling/reporting
- [ ] Add analytics (optional, privacy-respecting)
- [ ] Localization support
- [ ] Accessibility improvements (VoiceOver/TalkBack)

## Dependencies

Key packages from `pubspec.yaml`:
- `flutter_soloud: ^3.1.5` - Audio synthesis
- `audio_session: ^0.1.21` - Background audio configuration
- `flutter_riverpod: ^2.6.1` - State management
- `hive: ^2.2.3` / `hive_flutter: ^1.1.0` - Local storage for presets
- `shared_preferences: ^2.3.4` - Settings storage
- `uuid: ^4.5.1` - Unique ID generation
- `equatable: ^2.0.7` - Value equality
- `go_router: ^14.8.1` - Navigation (available for future use)

## Distribution

### GitHub Repository
- **Repository**: https://github.com/EMerdzhanov/HemiSync
- **Releases**: https://github.com/EMerdzhanov/HemiSync/releases
- **Web App**: https://emerdzhanov.github.io/HemiSync/

### Current Version: v1.1.0

### CI/CD Pipeline
GitHub Actions workflow (`.github/workflows/release.yml`) automatically builds for all platforms when a version tag is pushed:
- macOS: Creates DMG using `create-dmg`, includes ad-hoc code signing
- Windows: Creates Setup.exe using Inno Setup
- Android: Builds release APK
- Web: Builds and deploys to GitHub Pages

### macOS Installation Note
Since the app is not notarized with Apple, users must run this command after installation:
```bash
xattr -cr /Applications/hemissync.app
```

### Triggering a Release
```bash
# Update version in pubspec.yaml first
git add -A
git commit -m "Release vX.Y.Z"
git push origin main
git tag vX.Y.Z
git push origin vX.Y.Z
```

## Version History

### v1.1.0 (2026-01-12)
- Increased default macOS window size to 850px height
- Set minimum window size to prevent controls from being cut off
- Fixed app title to "HemiSync" (was "hemissync")
- Updated macOS icons with rounded corners (macOS style)
- Fixed CardTheme compatibility with Flutter 3.24.0
- Updated README with correct installation instructions
- Added Terminal command for macOS Gatekeeper bypass

### v1.0.x (2026-01-11)
- Initial GitHub release
- Added Windows platform support
- Created GitHub Actions CI/CD pipeline
- Setup macOS DMG and Windows Setup.exe installers
- Deployed web version to GitHub Pages

## Notes

- The frequency slider uses logarithmic scaling for better UX across the wide frequency range
- Frequencies are clamped between 1 Hz and 25,000 Hz
- The app maintains audio session for background playback on mobile
- Presets are stored locally using Hive with TypeAdapters
- Flutter version 3.24.0 is used in CI (specified in workflow)
- Use `CardTheme` (not `CardThemeData`) for Flutter 3.24.0 compatibility
