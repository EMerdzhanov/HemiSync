import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/audio_constants.dart';

class BeatInfoDisplay extends StatelessWidget {
  const BeatInfoDisplay({
    super.key,
    required this.leftFrequency,
    required this.rightFrequency,
  });

  final double leftFrequency;
  final double rightFrequency;

  double get binauralBeat => (leftFrequency - rightFrequency).abs();

  BrainwaveCategory get category =>
      BrainwaveCategory.fromFrequency(binauralBeat);

  Color _getCategoryColor() {
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Binaural Beat',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                binauralBeat.toStringAsFixed(1),
                style: TextStyle(
                  color: color,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'Hz',
                style: TextStyle(
                  color: color.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${category.name} - ${category.description}',
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
