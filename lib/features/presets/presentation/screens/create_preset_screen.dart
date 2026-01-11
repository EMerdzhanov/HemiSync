import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/audio_constants.dart';
import '../../../../core/widgets/frequency_slider.dart';
import '../../../../core/widgets/waveform_selector.dart';
import '../../../audio_engine/domain/entities/waveform_type.dart';
import '../../domain/entities/preset.dart';
import '../providers/presets_provider.dart';

class CreatePresetScreen extends ConsumerStatefulWidget {
  const CreatePresetScreen({super.key, this.preset});

  final Preset? preset;

  @override
  ConsumerState<CreatePresetScreen> createState() => _CreatePresetScreenState();
}

class _CreatePresetScreenState extends ConsumerState<CreatePresetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late double _leftFrequency;
  late double _rightFrequency;
  late WaveformType _waveform;
  late int _durationMinutes;
  late PresetCategory _category;

  bool get _isEditing => widget.preset != null;

  @override
  void initState() {
    super.initState();
    final preset = widget.preset;
    _nameController = TextEditingController(text: preset?.name ?? '');
    _descriptionController =
        TextEditingController(text: preset?.description ?? '');
    _leftFrequency = preset?.leftFrequency ?? AudioConstants.defaultFrequency;
    _rightFrequency =
        preset?.rightFrequency ?? AudioConstants.defaultFrequency + 10;
    _waveform = preset?.waveform ?? WaveformType.sine;
    _durationMinutes = preset?.defaultDuration.inMinutes ?? 15;
    _category = preset?.category ?? PresetCategory.custom;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _savePreset() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for the preset'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_isEditing) {
      ref.read(presetsProvider.notifier).updatePreset(
            widget.preset!.copyWith(
              name: _nameController.text.trim(),
              description: _descriptionController.text.trim().isEmpty
                  ? null
                  : _descriptionController.text.trim(),
              leftFrequency: _leftFrequency,
              rightFrequency: _rightFrequency,
              waveform: _waveform,
              defaultDuration: Duration(minutes: _durationMinutes),
              category: _category,
            ),
          );
    } else {
      ref.read(presetsProvider.notifier).createPreset(
            name: _nameController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            leftFrequency: _leftFrequency,
            rightFrequency: _rightFrequency,
            waveform: _waveform,
            defaultDuration: Duration(minutes: _durationMinutes),
            category: _category,
          );
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final binauralBeat = (_leftFrequency - _rightFrequency).abs();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text(
          _isEditing ? 'Edit Preset' : 'Create Preset',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _savePreset,
            child: const Text(
              'Save',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            TextField(
              controller: _nameController,
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                labelText: 'Preset Name',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Description field
            TextField(
              controller: _descriptionController,
              style: const TextStyle(color: AppColors.textPrimary),
              maxLines: 2,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: const TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Binaural beat preview
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Binaural Beat',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '${binauralBeat.toStringAsFixed(1)} Hz',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Frequency sliders
            Row(
              children: [
                Expanded(
                  child: FrequencySlider(
                    label: 'LEFT EAR',
                    frequency: _leftFrequency,
                    color: AppColors.leftChannel,
                    onChanged: (freq) {
                      setState(() {
                        _leftFrequency = freq;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FrequencySlider(
                    label: 'RIGHT EAR',
                    frequency: _rightFrequency,
                    color: AppColors.rightChannel,
                    onChanged: (freq) {
                      setState(() {
                        _rightFrequency = freq;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Waveform selector
            const Text(
              'Waveform',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            WaveformSelector(
              selected: _waveform,
              onChanged: (waveform) {
                setState(() {
                  _waveform = waveform;
                });
              },
            ),
            const SizedBox(height: 32),

            // Duration
            const Text(
              'Default Duration',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [5, 10, 15, 20, 30, 45, 60].map((minutes) {
                final isSelected = minutes == _durationMinutes;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _durationMinutes = minutes;
                    });
                  },
                  child: Container(
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
                        color:
                            isSelected ? AppColors.primary : AppColors.border,
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
            const SizedBox(height: 32),

            // Category
            const Text(
              'Category',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: PresetCategory.values.map((category) {
                final isSelected = category == _category;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _category = category;
                    });
                  },
                  child: Container(
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
                        color:
                            isSelected ? AppColors.primary : AppColors.border,
                      ),
                    ),
                    child: Text(
                      category.displayName,
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
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
