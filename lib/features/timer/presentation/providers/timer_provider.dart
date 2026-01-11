import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/session_timer.dart';
import '../../../audio_engine/presentation/providers/audio_engine_provider.dart';

final timerProvider =
    StateNotifierProvider<TimerNotifier, SessionTimer>((ref) {
  return TimerNotifier(ref);
});

class TimerNotifier extends StateNotifier<SessionTimer> {
  TimerNotifier(this._ref) : super(SessionTimer.idle());

  final Ref _ref;
  Timer? _timer;

  void start(Duration duration, {bool fadeOut = true}) {
    _timer?.cancel();

    state = SessionTimer(
      totalDuration: duration,
      remainingDuration: duration,
      isRunning: true,
      fadeOutEnabled: fadeOut,
    );

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _onTick(),
    );
  }

  void _onTick() {
    if (state.remainingDuration <= Duration.zero) {
      stop();
      _ref.read(playbackStateProvider.notifier).stop();
      return;
    }

    // Check for fade out
    if (state.shouldStartFadeOut && state.remainingDuration == state.fadeOutDuration) {
      _ref.read(playbackStateProvider.notifier).fadeVolume(
        0.0,
        state.fadeOutDuration,
      );
    }

    state = state.copyWith(
      remainingDuration: state.remainingDuration - const Duration(seconds: 1),
    );

    // Update playback state with remaining time
    _ref.read(playbackStateProvider.notifier).setRemainingTime(
      state.remainingDuration,
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    state = SessionTimer.idle();
    _ref.read(playbackStateProvider.notifier).setRemainingTime(null);
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isRunning: false);
  }

  void resume() {
    if (state.remainingDuration > Duration.zero) {
      state = state.copyWith(isRunning: true);
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => _onTick(),
      );
    }
  }

  void addTime(Duration duration) {
    state = state.copyWith(
      totalDuration: state.totalDuration + duration,
      remainingDuration: state.remainingDuration + duration,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
