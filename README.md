# HemiSync

A cross-platform binaural beats generator with independent left/right ear frequency control.

## What are Binaural Beats?

Binaural beats are an auditory illusion created when two slightly different frequencies are played in each ear. Your brain perceives a third "beat" frequency equal to the difference between the two tones. This effect is used for meditation, relaxation, focus, and sleep.

## Features

- Independent left/right ear frequency control (1 Hz - 25 kHz)
- Multiple waveform types: Sine, Square, Triangle, Sawtooth
- Real-time beat frequency display with brainwave category
- Tap-to-edit frequency input for precise control
- Fine-tuning with +/- buttons
- Session timer with auto-stop
- Preset management (save and load your favorite settings)
- Background audio playback
- Dark theme optimized for relaxation

## Brainwave Categories

| Category | Frequency | Effect |
|----------|-----------|--------|
| Delta | 0.5 - 4 Hz | Deep sleep, healing |
| Theta | 4 - 8 Hz | Meditation, creativity |
| Alpha | 8 - 14 Hz | Relaxation, calm focus |
| Beta | 14 - 30 Hz | Focus, concentration |
| Gamma | 30 - 100 Hz | Peak awareness, insight |

## Download

### macOS
1. Download `HemiSync-macOS.dmg` from the [Releases](../../releases) page
2. Open the DMG and drag the app to your Applications folder
3. Open Terminal and run:
   ```
   xattr -cr /Applications/hemissync.app
   ```
4. Now you can open the app normally

> **Note**: The Terminal command is required because the app is not notarized with Apple. This only needs to be done once.

### Windows
1. Download `HemiSync-Windows-Setup.exe` from the [Releases](../../releases) page
2. Run the installer and follow the prompts
3. Launch HemiSync from the Start Menu or Desktop shortcut

### Android
1. Download `HemiSync-Android.apk` from the [Releases](../../releases) page
2. Enable **Install from unknown sources** in your device settings
3. Open the APK file to install

### Web
Visit the [HemiSync Web App](https://emerdzhanov.github.io/HemiSync/) to use directly in your browser.

## Building from Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.10+)
- Xcode (for macOS/iOS)
- Android Studio (for Android)
- Visual Studio (for Windows)

### Build Commands

```bash
# Get dependencies
flutter pub get

# macOS
flutter build macos --release

# Windows
flutter build windows --release

# Android
flutter build apk --release

# Web
flutter build web --release

# iOS (requires Apple Developer account)
flutter build ios --release
```

## Usage Tips

1. **Use headphones** - Binaural beats only work when each ear receives a different frequency
2. **Start with Alpha waves** (8-14 Hz) - Good for general relaxation
3. **Keep base frequency between 100-500 Hz** - Most comfortable for extended listening
4. **Use the timer** - Sessions of 15-30 minutes are typical

## License

MIT License - see LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
