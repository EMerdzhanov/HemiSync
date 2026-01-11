import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/playback_state.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    super.key,
    required this.status,
    required this.onPressed,
    this.size = 80,
  });

  final PlaybackStatus status;
  final VoidCallback onPressed;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isPlaying = status == PlaybackStatus.playing;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPlaying ? AppColors.primary : AppColors.surface,
          border: Border.all(
            color: AppColors.primary,
            width: 3,
          ),
          boxShadow: isPlaying
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Icon(
            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            key: ValueKey(isPlaying),
            size: size * 0.5,
            color: isPlaying ? AppColors.background : AppColors.primary,
          ),
        ),
      ),
    );
  }
}
