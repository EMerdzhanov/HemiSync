import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/frequency_slider.dart';
import '../../../../core/widgets/waveform_selector.dart';
import '../../../audio_engine/presentation/providers/audio_engine_provider.dart';
import '../../../timer/presentation/providers/timer_provider.dart';
import '../../../timer/presentation/widgets/timer_display.dart';
import '../../../timer/presentation/widgets/timer_picker.dart';
import '../widgets/beat_info_display.dart';
import '../widgets/play_pause_button.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key});

  void _showTimerPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => TimerPicker(
        onDurationSelected: (duration) {
          ref.read(timerProvider.notifier).start(duration);
          // Auto-play when timer starts
          final playbackState = ref.read(playbackStateProvider);
          if (!playbackState.isPlaying) {
            ref.read(playbackStateProvider.notifier).play();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playbackState = ref.watch(playbackStateProvider);
    final timer = ref.watch(timerProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'HemiSync',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music_outlined),
            color: AppColors.textSecondary,
            onPressed: () {
              // Navigate to presets
              Navigator.pushNamed(context, '/presets');
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            color: AppColors.textSecondary,
            onPressed: () {
              // Navigate to settings
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 16),

              // Beat Info Display
              BeatInfoDisplay(
                leftFrequency: playbackState.leftChannel.frequency,
                rightFrequency: playbackState.rightChannel.frequency,
              ),

              const SizedBox(height: 32),

              // Frequency Sliders
              Row(
                children: [
                  Expanded(
                    child: FrequencySlider(
                      label: 'LEFT EAR',
                      frequency: playbackState.leftChannel.frequency,
                      color: AppColors.leftChannel,
                      onChanged: (freq) {
                        ref
                            .read(playbackStateProvider.notifier)
                            .setLeftFrequency(freq);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FrequencySlider(
                      label: 'RIGHT EAR',
                      frequency: playbackState.rightChannel.frequency,
                      color: AppColors.rightChannel,
                      onChanged: (freq) {
                        ref
                            .read(playbackStateProvider.notifier)
                            .setRightFrequency(freq);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Waveform Selector
              WaveformSelector(
                selected: playbackState.waveform,
                onChanged: (waveform) {
                  ref
                      .read(playbackStateProvider.notifier)
                      .setWaveform(waveform);
                },
              ),

              const SizedBox(height: 40),

              // Play/Pause Button
              PlayPauseButton(
                status: playbackState.status,
                onPressed: () {
                  ref.read(playbackStateProvider.notifier).togglePlayPause();
                },
              ),

              const SizedBox(height: 32),

              // Volume Slider
              Row(
                children: [
                  Icon(
                    Icons.volume_down,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: const SliderThemeData(
                        activeTrackColor: AppColors.primary,
                        inactiveTrackColor: AppColors.surfaceLight,
                        thumbColor: AppColors.primary,
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: playbackState.masterVolume,
                        onChanged: (value) {
                          ref
                              .read(playbackStateProvider.notifier)
                              .setVolume(value);
                        },
                      ),
                    ),
                  ),
                  Icon(
                    Icons.volume_up,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Timer Display
              TimerDisplay(
                timer: timer,
                onTap: () => _showTimerPicker(context, ref),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
