import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../audio_engine/presentation/providers/audio_engine_provider.dart';
import '../../domain/entities/preset.dart';
import '../providers/presets_provider.dart';
import '../widgets/preset_card.dart';
import 'create_preset_screen.dart';

class PresetsScreen extends ConsumerStatefulWidget {
  const PresetsScreen({super.key});

  @override
  ConsumerState<PresetsScreen> createState() => _PresetsScreenState();
}

class _PresetsScreenState extends ConsumerState<PresetsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _playPreset(Preset preset) {
    ref.read(playbackStateProvider.notifier).loadPreset(
          leftFrequency: preset.leftFrequency,
          rightFrequency: preset.rightFrequency,
          waveform: preset.waveform,
        );
    ref.read(playbackStateProvider.notifier).play();
    Navigator.pop(context);
  }

  void _deletePreset(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Preset',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to delete this preset?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(presetsProvider.notifier).deletePreset(id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final presetsState = ref.watch(presetsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Presets',
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: const [
            Tab(text: 'Built-in'),
            Tab(text: 'My Presets'),
          ],
        ),
      ),
      body: presetsState.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            'Error loading presets: $error',
            style: const TextStyle(color: AppColors.error),
          ),
        ),
        data: (presets) {
          final builtIn = presets.where((p) => p.isBuiltIn).toList();
          final custom = presets.where((p) => !p.isBuiltIn).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildPresetsList(builtIn, showDelete: false),
              _buildPresetsList(custom, showDelete: true, isEmpty: custom.isEmpty),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePresetScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.background,
        ),
      ),
    );
  }

  Widget _buildPresetsList(
    List<Preset> presets, {
    required bool showDelete,
    bool isEmpty = false,
  }) {
    if (isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.library_music_outlined,
              size: 64,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            const Text(
              'No custom presets yet',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap + to create one',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: presets.length,
      itemBuilder: (context, index) {
        final preset = presets[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: PresetCard(
            preset: preset,
            onTap: () => _playPreset(preset),
            onPlay: () => _playPreset(preset),
            onDelete: showDelete ? () => _deletePreset(preset.id) : null,
          ),
        );
      },
    );
  }
}
