import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../features/audio_engine/domain/entities/waveform_type.dart';

class WaveformSelector extends StatelessWidget {
  const WaveformSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final WaveformType selected;
  final ValueChanged<WaveformType> onChanged;

  IconData _getIcon(WaveformType type) {
    switch (type) {
      case WaveformType.sine:
        return Icons.waves;
      case WaveformType.square:
        return Icons.square_outlined;
      case WaveformType.triangle:
        return Icons.change_history;
      case WaveformType.sawtooth:
        return Icons.show_chart;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: WaveformType.values.map((type) {
        final isSelected = type == selected;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onChanged(type),
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.2)
                      : AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getIcon(type),
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                      size: 24,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      type.displayName,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        fontSize: 10,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
