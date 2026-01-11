import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AudioBackgroundService {
  static Future<void> configure() async {
    // Skip audio session configuration on web
    if (kIsWeb) return;

    final session = await AudioSession.instance;

    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.mixWithOthers,
      avAudioSessionMode: AVAudioSessionMode.defaultMode,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
        flags: AndroidAudioFlags.none,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: false,
    ));

    // Handle interruptions (phone calls, etc.)
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        // Audio interrupted (phone call, etc.)
        // The player should pause
      } else {
        // Interruption ended
        // The player can resume if appropriate
      }
    });

    // Handle becoming noisy (headphones unplugged)
    session.becomingNoisyEventStream.listen((_) {
      // Headphones unplugged - should pause playback
    });

    await session.setActive(true);
  }

  static Future<void> deactivate() async {
    if (kIsWeb) return;

    final session = await AudioSession.instance;
    await session.setActive(false);
  }
}
