import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/session_timer.dart';

class TimerDisplay extends StatelessWidget {
  const TimerDisplay({
    super.key,
    required this.timer,
    required this.onTap,
  });

  final SessionTimer timer;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isActive = timer.isRunning || timer.remainingDuration > Duration.zero;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.border,
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.timer_outlined,
              color: isActive ? AppColors.accent : AppColors.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              isActive ? timer.formattedRemaining : 'Set Timer',
              style: TextStyle(
                color: isActive ? AppColors.accent : AppColors.textSecondary,
                fontSize: 16,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
