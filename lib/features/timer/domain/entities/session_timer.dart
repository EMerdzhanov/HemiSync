import 'package:equatable/equatable.dart';

class SessionTimer extends Equatable {
  const SessionTimer({
    required this.totalDuration,
    required this.remainingDuration,
    this.isRunning = false,
    this.fadeOutEnabled = true,
    this.fadeOutDuration = const Duration(seconds: 10),
  });

  factory SessionTimer.idle() {
    return const SessionTimer(
      totalDuration: Duration.zero,
      remainingDuration: Duration.zero,
      isRunning: false,
    );
  }

  final Duration totalDuration;
  final Duration remainingDuration;
  final bool isRunning;
  final bool fadeOutEnabled;
  final Duration fadeOutDuration;

  double get progress {
    if (totalDuration.inSeconds == 0) return 0;
    return 1 - (remainingDuration.inSeconds / totalDuration.inSeconds);
  }

  bool get shouldStartFadeOut =>
      fadeOutEnabled && remainingDuration <= fadeOutDuration;

  bool get isComplete => remainingDuration <= Duration.zero && isRunning;

  String get formattedRemaining {
    final hours = remainingDuration.inHours;
    final minutes = remainingDuration.inMinutes.remainder(60);
    final seconds = remainingDuration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  SessionTimer copyWith({
    Duration? totalDuration,
    Duration? remainingDuration,
    bool? isRunning,
    bool? fadeOutEnabled,
    Duration? fadeOutDuration,
  }) {
    return SessionTimer(
      totalDuration: totalDuration ?? this.totalDuration,
      remainingDuration: remainingDuration ?? this.remainingDuration,
      isRunning: isRunning ?? this.isRunning,
      fadeOutEnabled: fadeOutEnabled ?? this.fadeOutEnabled,
      fadeOutDuration: fadeOutDuration ?? this.fadeOutDuration,
    );
  }

  @override
  List<Object?> get props => [
        totalDuration,
        remainingDuration,
        isRunning,
        fadeOutEnabled,
        fadeOutDuration,
      ];
}
