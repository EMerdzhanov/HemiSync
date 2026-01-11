import 'package:equatable/equatable.dart';
import 'waveform_type.dart';

class AudioChannel extends Equatable {
  const AudioChannel({
    required this.frequency,
    this.volume = 1.0,
    this.waveform = WaveformType.sine,
    required this.isLeft,
  });

  final double frequency;
  final double volume;
  final WaveformType waveform;
  final bool isLeft;

  AudioChannel copyWith({
    double? frequency,
    double? volume,
    WaveformType? waveform,
    bool? isLeft,
  }) {
    return AudioChannel(
      frequency: frequency ?? this.frequency,
      volume: volume ?? this.volume,
      waveform: waveform ?? this.waveform,
      isLeft: isLeft ?? this.isLeft,
    );
  }

  @override
  List<Object?> get props => [frequency, volume, waveform, isLeft];
}
