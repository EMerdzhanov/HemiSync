import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Audio'),
          _buildSettingsTile(
            title: 'Default Volume',
            subtitle:
                '${(settings.defaultVolume * 100).round()}%',
            trailing: SizedBox(
              width: 150,
              child: Slider(
                value: settings.defaultVolume,
                activeColor: AppColors.primary,
                inactiveColor: AppColors.surfaceLight,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setDefaultVolume(value);
                },
              ),
            ),
          ),
          _buildSettingsTile(
            title: 'Background Audio',
            subtitle: 'Continue playing when screen is off',
            trailing: Switch(
              value: settings.enableBackgroundAudio,
              activeTrackColor: AppColors.primary,
              onChanged: (value) {
                ref
                    .read(settingsProvider.notifier)
                    .setEnableBackgroundAudio(value);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Display'),
          _buildSettingsTile(
            title: 'Keep Screen On',
            subtitle: 'Prevent screen from turning off during sessions',
            trailing: Switch(
              value: settings.keepScreenOn,
              activeTrackColor: AppColors.primary,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setKeepScreenOn(value);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildSettingsTile(
            title: 'HemiSync',
            subtitle: 'Version 1.0.0',
            onTap: () {},
          ),
          _buildSettingsTile(
            title: 'About Binaural Beats',
            subtitle: 'Learn how binaural beats work',
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'About Binaural Beats',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Binaural beats are an auditory illusion created when two slightly different frequencies are played in each ear. Your brain perceives a third tone - the "binaural beat" - at the difference between the two frequencies.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),
              Text(
                'Brainwave Categories:',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Delta (0.5-4 Hz): Deep sleep, healing\n'
                'Theta (4-8 Hz): Meditation, creativity\n'
                'Alpha (8-14 Hz): Relaxation, calm focus\n'
                'Beta (14-30 Hz): Focus, concentration\n'
                'Gamma (30+ Hz): Peak awareness',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              SizedBox(height: 16),
              Text(
                'Important: Use headphones for the binaural effect to work. Each ear must receive a different frequency.',
                style: TextStyle(
                  color: AppColors.accent,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
