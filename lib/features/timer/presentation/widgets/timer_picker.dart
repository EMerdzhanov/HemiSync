import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class TimerPicker extends StatefulWidget {
  const TimerPicker({
    super.key,
    required this.onDurationSelected,
    this.initialDuration,
  });

  final ValueChanged<Duration> onDurationSelected;
  final Duration? initialDuration;

  @override
  State<TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  late int _selectedMinutes;
  bool _fadeOutEnabled = true;

  final List<int> _quickPresets = [5, 10, 15, 20, 30, 45, 60, 90];

  @override
  void initState() {
    super.initState();
    _selectedMinutes = widget.initialDuration?.inMinutes ?? 15;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Session Timer',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.close,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Presets',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPresets.map((minutes) {
              final isSelected = minutes == _selectedMinutes;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMinutes = minutes;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.border,
                    ),
                  ),
                  child: Text(
                    '$minutes min',
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.background
                          : AppColors.textPrimary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Custom Duration',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: const SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: AppColors.primary,
              trackHeight: 6,
            ),
            child: Slider(
              value: _selectedMinutes.toDouble(),
              min: 1,
              max: 120,
              divisions: 119,
              label: '$_selectedMinutes min',
              onChanged: (value) {
                setState(() {
                  _selectedMinutes = value.round();
                });
              },
            ),
          ),
          Center(
            child: Text(
              '$_selectedMinutes minutes',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Checkbox(
                value: _fadeOutEnabled,
                onChanged: (value) {
                  setState(() {
                    _fadeOutEnabled = value ?? true;
                  });
                },
                activeColor: AppColors.primary,
              ),
              const Text(
                'Fade out at end',
                style: TextStyle(
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              widget.onDurationSelected(Duration(minutes: _selectedMinutes));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start Timer',
              style: TextStyle(
                color: AppColors.background,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
