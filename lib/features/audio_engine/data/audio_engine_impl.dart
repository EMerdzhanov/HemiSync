import 'package:flutter_soloud/flutter_soloud.dart';
import '../domain/entities/audio_channel.dart';
import '../domain/entities/waveform_type.dart';
import '../domain/repositories/audio_engine_repository.dart';

class AudioEngineImpl implements AudioEngineRepository {
  SoLoud? _soloud;
  AudioSource? _leftSource;
  AudioSource? _rightSource;
  SoundHandle? _leftHandle;
  SoundHandle? _rightHandle;
  bool _isInitialized = false;
  bool _isPlaying = false;
  double _currentVolume = 0.8;

  @override
  bool get isPlaying => _isPlaying;

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    _soloud = SoLoud.instance;
    await _soloud!.init();
    _isInitialized = true;
  }

  @override
  Future<void> dispose() async {
    await stop();
    if (_isInitialized && _soloud != null) {
      _soloud!.deinit();
      _isInitialized = false;
    }
  }

  @override
  Future<void> playBinauralBeat(AudioChannel left, AudioChannel right) async {
    if (!_isInitialized || _soloud == null) {
      await initialize();
    }

    // Stop any existing playback
    await stop();

    // Create left channel waveform (positional args: waveform, superWave, scale, detune)
    _leftSource = await _soloud!.loadWaveform(
      left.waveform.toSoLoudWaveForm(),
      false, // superWave
      1.0,   // scale
      0.0,   // detune
    );
    _soloud!.setWaveformFreq(_leftSource!, left.frequency);

    // Create right channel waveform
    _rightSource = await _soloud!.loadWaveform(
      right.waveform.toSoLoudWaveForm(),
      false, // superWave
      1.0,   // scale
      0.0,   // detune
    );
    _soloud!.setWaveformFreq(_rightSource!, right.frequency);

    // Play both channels
    _leftHandle = await _soloud!.play(
      _leftSource!,
      volume: _currentVolume * left.volume,
    );
    _rightHandle = await _soloud!.play(
      _rightSource!,
      volume: _currentVolume * right.volume,
    );

    // Pan left channel fully left (1.0 left, 0.0 right)
    _soloud!.setPanAbsolute(_leftHandle!, 1.0, 0.0);

    // Pan right channel fully right (0.0 left, 1.0 right)
    _soloud!.setPanAbsolute(_rightHandle!, 0.0, 1.0);

    _isPlaying = true;
  }

  @override
  Future<void> stop() async {
    if (_soloud == null) return;

    if (_leftHandle != null) {
      _soloud!.stop(_leftHandle!);
      _leftHandle = null;
    }
    if (_rightHandle != null) {
      _soloud!.stop(_rightHandle!);
      _rightHandle = null;
    }

    if (_leftSource != null) {
      await _soloud!.disposeSource(_leftSource!);
      _leftSource = null;
    }
    if (_rightSource != null) {
      await _soloud!.disposeSource(_rightSource!);
      _rightSource = null;
    }

    _isPlaying = false;
  }

  @override
  Future<void> pause() async {
    if (_soloud == null || !_isPlaying) return;

    if (_leftHandle != null) {
      _soloud!.setPause(_leftHandle!, true);
    }
    if (_rightHandle != null) {
      _soloud!.setPause(_rightHandle!, true);
    }
    _isPlaying = false;
  }

  @override
  Future<void> resume() async {
    if (_soloud == null) return;

    if (_leftHandle != null) {
      _soloud!.setPause(_leftHandle!, false);
    }
    if (_rightHandle != null) {
      _soloud!.setPause(_rightHandle!, false);
    }
    _isPlaying = true;
  }

  @override
  void setLeftFrequency(double frequency) {
    if (_soloud != null && _leftSource != null) {
      _soloud!.setWaveformFreq(_leftSource!, frequency);
    }
  }

  @override
  void setRightFrequency(double frequency) {
    if (_soloud != null && _rightSource != null) {
      _soloud!.setWaveformFreq(_rightSource!, frequency);
    }
  }

  @override
  void setWaveform(WaveformType waveform) {
    // Waveform change requires restarting playback
    // This is handled by the provider
  }

  @override
  void setVolume(double volume) {
    _currentVolume = volume;
    if (_soloud != null) {
      if (_leftHandle != null) {
        _soloud!.setVolume(_leftHandle!, volume);
      }
      if (_rightHandle != null) {
        _soloud!.setVolume(_rightHandle!, volume);
      }
    }
  }

  @override
  void fadeVolume(double targetVolume, Duration duration) {
    if (_soloud != null) {
      if (_leftHandle != null) {
        _soloud!.fadeVolume(_leftHandle!, targetVolume, duration);
      }
      if (_rightHandle != null) {
        _soloud!.fadeVolume(_rightHandle!, targetVolume, duration);
      }
    }
    _currentVolume = targetVolume;
  }
}
