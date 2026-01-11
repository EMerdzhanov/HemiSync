import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/audio_engine_impl.dart';
import '../../domain/entities/audio_channel.dart';
import '../../domain/entities/waveform_type.dart';
import '../../domain/repositories/audio_engine_repository.dart';
import '../../../player/domain/entities/playback_state.dart';
import '../../../../core/constants/audio_constants.dart';

final audioEngineRepositoryProvider = Provider<AudioEngineRepository>((ref) {
  final engine = AudioEngineImpl();
  ref.onDispose(() => engine.dispose());
  return engine;
});

final playbackStateProvider =
    StateNotifierProvider<PlaybackStateNotifier, PlaybackState>((ref) {
  final engine = ref.watch(audioEngineRepositoryProvider);
  return PlaybackStateNotifier(engine);
});

class PlaybackStateNotifier extends StateNotifier<PlaybackState> {
  PlaybackStateNotifier(this._engine) : super(PlaybackState.initial()) {
    _initEngine();
  }

  final AudioEngineRepository _engine;

  Future<void> _initEngine() async {
    await _engine.initialize();
  }

  Future<void> play() async {
    await _engine.playBinauralBeat(state.leftChannel, state.rightChannel);
    state = state.copyWith(status: PlaybackStatus.playing);
  }

  Future<void> stop() async {
    await _engine.stop();
    state = state.copyWith(status: PlaybackStatus.stopped);
  }

  Future<void> pause() async {
    await _engine.pause();
    state = state.copyWith(status: PlaybackStatus.paused);
  }

  Future<void> resume() async {
    await _engine.resume();
    state = state.copyWith(status: PlaybackStatus.playing);
  }

  Future<void> togglePlayPause() async {
    if (state.isPlaying) {
      await pause();
    } else if (state.status == PlaybackStatus.paused) {
      await resume();
    } else {
      await play();
    }
  }

  void setLeftFrequency(double frequency) {
    frequency = frequency.clamp(
      AudioConstants.minFrequency,
      AudioConstants.maxFrequency,
    );
    _engine.setLeftFrequency(frequency);
    state = state.copyWith(
      leftChannel: state.leftChannel.copyWith(frequency: frequency),
    );
  }

  void setRightFrequency(double frequency) {
    frequency = frequency.clamp(
      AudioConstants.minFrequency,
      AudioConstants.maxFrequency,
    );
    _engine.setRightFrequency(frequency);
    state = state.copyWith(
      rightChannel: state.rightChannel.copyWith(frequency: frequency),
    );
  }

  Future<void> setWaveform(WaveformType waveform) async {
    final wasPlaying = state.isPlaying;

    state = state.copyWith(
      leftChannel: state.leftChannel.copyWith(waveform: waveform),
      rightChannel: state.rightChannel.copyWith(waveform: waveform),
    );

    // Restart playback with new waveform if was playing
    if (wasPlaying) {
      await _engine.stop();
      await _engine.playBinauralBeat(state.leftChannel, state.rightChannel);
    }
  }

  void setVolume(double volume) {
    volume = volume.clamp(0.0, 1.0);
    _engine.setVolume(volume);
    state = state.copyWith(masterVolume: volume);
  }

  void fadeVolume(double targetVolume, Duration duration) {
    _engine.fadeVolume(targetVolume, duration);
    state = state.copyWith(masterVolume: targetVolume);
  }

  void setRemainingTime(Duration? remaining) {
    state = state.copyWith(remainingTime: remaining);
  }

  Future<void> loadPreset({
    required double leftFrequency,
    required double rightFrequency,
    required WaveformType waveform,
  }) async {
    final wasPlaying = state.isPlaying;

    state = state.copyWith(
      leftChannel: AudioChannel(
        frequency: leftFrequency,
        waveform: waveform,
        isLeft: true,
      ),
      rightChannel: AudioChannel(
        frequency: rightFrequency,
        waveform: waveform,
        isLeft: false,
      ),
    );

    if (wasPlaying) {
      await _engine.stop();
      await _engine.playBinauralBeat(state.leftChannel, state.rightChannel);
    }
  }
}
