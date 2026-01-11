import 'package:equatable/equatable.dart';
import '../../../audio_engine/domain/entities/audio_channel.dart';
import '../../../audio_engine/domain/entities/waveform_type.dart';
import '../../../../core/constants/audio_constants.dart';

enum PlaybackStatus { stopped, playing, paused }

class PlaybackState extends Equatable {
  const PlaybackState({
    this.status = PlaybackStatus.stopped,
    required this.leftChannel,
    required this.rightChannel,
    this.masterVolume = 0.8,
    this.remainingTime,
  });

  factory PlaybackState.initial() {
    return PlaybackState(
      leftChannel: const AudioChannel(
        frequency: AudioConstants.defaultFrequency,
        isLeft: true,
      ),
      rightChannel: const AudioChannel(
        frequency: AudioConstants.defaultFrequency + 10,
        isLeft: false,
      ),
    );
  }

  final PlaybackStatus status;
  final AudioChannel leftChannel;
  final AudioChannel rightChannel;
  final double masterVolume;
  final Duration? remainingTime;

  double get binauralBeatFrequency =>
      (leftChannel.frequency - rightChannel.frequency).abs();

  double get baseFrequency =>
      (leftChannel.frequency + rightChannel.frequency) / 2;

  BrainwaveCategory get beatCategory =>
      BrainwaveCategory.fromFrequency(binauralBeatFrequency);

  bool get isPlaying => status == PlaybackStatus.playing;

  WaveformType get waveform => leftChannel.waveform;

  PlaybackState copyWith({
    PlaybackStatus? status,
    AudioChannel? leftChannel,
    AudioChannel? rightChannel,
    double? masterVolume,
    Duration? remainingTime,
  }) {
    return PlaybackState(
      status: status ?? this.status,
      leftChannel: leftChannel ?? this.leftChannel,
      rightChannel: rightChannel ?? this.rightChannel,
      masterVolume: masterVolume ?? this.masterVolume,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }

  @override
  List<Object?> get props =>
      [status, leftChannel, rightChannel, masterVolume, remainingTime];
}
