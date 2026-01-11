import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/audio_constants.dart';

class FrequencySlider extends StatelessWidget {
  const FrequencySlider({
    super.key,
    required this.label,
    required this.frequency,
    required this.onChanged,
    this.color = AppColors.primary,
    this.min = AudioConstants.minFrequency,
    this.max = AudioConstants.maxFrequency,
  });

  final String label;
  final double frequency;
  final ValueChanged<double> onChanged;
  final Color color;
  final double min;
  final double max;

  // Convert linear slider value (0-1) to logarithmic frequency
  double _sliderToFreq(double value) {
    final logMin = math.log(min);
    final logMax = math.log(max);
    return math.exp(logMin + value * (logMax - logMin));
  }

  // Convert logarithmic frequency to linear slider value (0-1)
  double _freqToSlider(double freq) {
    final logMin = math.log(min);
    final logMax = math.log(max);
    return (math.log(freq) - logMin) / (logMax - logMin);
  }

  String _formatFrequency(double freq) {
    if (freq >= 1000) {
      return '${(freq / 1000).toStringAsFixed(1)} kHz';
    }
    if (freq >= 100) {
      return '${freq.toStringAsFixed(0)} Hz';
    }
    return '${freq.toStringAsFixed(1)} Hz';
  }

  void _showFrequencyInputDialog(BuildContext context) {
    final controller = TextEditingController(
      text: frequency.toStringAsFixed(1),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          'Enter Frequency',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
          ],
          autofocus: true,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 24),
          decoration: InputDecoration(
            suffixText: 'Hz',
            suffixStyle: TextStyle(color: AppColors.textSecondary),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: color, width: 2),
            ),
          ),
          onSubmitted: (value) {
            _submitFrequency(context, value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => _submitFrequency(context, controller.text),
            child: Text('Set', style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }

  void _submitFrequency(BuildContext context, String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      final clamped = parsed.clamp(min, max);
      onChanged(clamped);
    }
    Navigator.pop(context);
  }

  void _adjustFrequency(double delta) {
    final newFreq = (frequency + delta).clamp(min, max);
    onChanged(newFreq);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        // Frequency display with up/down arrows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Down arrow button
            _AdjustButton(
              icon: Icons.remove,
              color: color,
              onTap: () => _adjustFrequency(-1),
              onLongPressStart: () => _adjustFrequency(-10),
            ),
            const SizedBox(width: 4),
            // Tappable frequency display
            GestureDetector(
              onTap: () => _showFrequencyInputDialog(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: color.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      _formatFrequency(frequency),
                      style: TextStyle(
                        color: color,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'tap to edit',
                      style: TextStyle(
                        color: color.withValues(alpha: 0.5),
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Up arrow button
            _AdjustButton(
              icon: Icons.add,
              color: color,
              onTap: () => _adjustFrequency(1),
              onLongPressStart: () => _adjustFrequency(10),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            inactiveTrackColor: color.withValues(alpha: 0.2),
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _freqToSlider(frequency).clamp(0.0, 1.0),
            onChanged: (value) {
              onChanged(_sliderToFreq(value));
            },
          ),
        ),
      ],
    );
  }
}

class _AdjustButton extends StatelessWidget {
  const _AdjustButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.onLongPressStart,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onLongPressStart;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPressStart,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 16,
        ),
      ),
    );
  }
}
