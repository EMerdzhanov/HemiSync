import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/audio_constants.dart';
import '../../domain/entities/preset.dart';

class PresetCard extends StatelessWidget {
  const PresetCard({
    super.key,
    required this.preset,
    required this.onTap,
    required this.onPlay,
    this.onDelete,
  });

  final Preset preset;
  final VoidCallback onTap;
  final VoidCallback onPlay;
  final VoidCallback? onDelete;

  Color _getCategoryColor() {
    final category = BrainwaveCategory.fromFrequency(preset.binauralBeat);
    switch (category) {
      case BrainwaveCategory.delta:
        return AppColors.deltaColor;
      case BrainwaveCategory.theta:
        return AppColors.thetaColor;
      case BrainwaveCategory.alpha:
        return AppColors.alphaColor;
      case BrainwaveCategory.beta:
        return AppColors.betaColor;
      case BrainwaveCategory.gamma:
        return AppColors.gammaColor;
      case BrainwaveCategory.none:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCategoryColor();
    final category = BrainwaveCategory.fromFrequency(preset.binauralBeat);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                if (!preset.isBuiltIn && onDelete != null)
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 18,
                    ),
                    color: AppColors.textMuted,
                    onPressed: onDelete,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              preset.name,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (preset.description != null) ...[
              const SizedBox(height: 4),
              Text(
                preset.description!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  '${preset.binauralBeat.toStringAsFixed(1)} Hz',
                  style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${preset.defaultDuration.inMinutes} min',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: onPlay,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: AppColors.background,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
