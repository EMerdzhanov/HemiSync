import '../entities/audio_channel.dart';
import '../entities/waveform_type.dart';

abstract class AudioEngineRepository {
  Future<void> initialize();
  Future<void> dispose();
  Future<void> playBinauralBeat(AudioChannel left, AudioChannel right);
  Future<void> stop();
  Future<void> pause();
  Future<void> resume();
  void setLeftFrequency(double frequency);
  void setRightFrequency(double frequency);
  void setWaveform(WaveformType waveform);
  void setVolume(double volume);
  void fadeVolume(double targetVolume, Duration duration);
  bool get isPlaying;
}
