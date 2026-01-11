import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../audio_engine/domain/entities/waveform_type.dart';
import '../../data/datasources/preset_local_datasource.dart';
import '../../domain/entities/preset.dart';

final presetDatasourceProvider = Provider<PresetLocalDatasource>((ref) {
  final datasource = PresetLocalDatasource();
  ref.onDispose(() => datasource.close());
  return datasource;
});

final presetsProvider =
    StateNotifierProvider<PresetsNotifier, AsyncValue<List<Preset>>>((ref) {
  final datasource = ref.watch(presetDatasourceProvider);
  return PresetsNotifier(datasource);
});

class PresetsNotifier extends StateNotifier<AsyncValue<List<Preset>>> {
  PresetsNotifier(this._datasource) : super(const AsyncValue.loading()) {
    _loadPresets();
  }

  final PresetLocalDatasource _datasource;
  final _uuid = const Uuid();

  Future<void> _loadPresets() async {
    state = const AsyncValue.loading();
    try {
      await _datasource.initialize();
      final presets = await _datasource.getAllPresets();
      state = AsyncValue.data(presets);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    await _loadPresets();
  }

  Future<void> createPreset({
    required String name,
    String? description,
    required double leftFrequency,
    required double rightFrequency,
    WaveformType waveform = WaveformType.sine,
    Duration defaultDuration = const Duration(minutes: 15),
    PresetCategory category = PresetCategory.custom,
  }) async {
    final preset = Preset(
      id: _uuid.v4(),
      name: name,
      description: description,
      leftFrequency: leftFrequency,
      rightFrequency: rightFrequency,
      waveform: waveform,
      defaultDuration: defaultDuration,
      category: category,
      isBuiltIn: false,
      createdAt: DateTime.now(),
    );

    await _datasource.savePreset(preset);
    await _loadPresets();
  }

  Future<void> updatePreset(Preset preset) async {
    if (preset.isBuiltIn) return; // Can't edit built-in presets

    final updated = preset.copyWith(updatedAt: DateTime.now());
    await _datasource.savePreset(updated);
    await _loadPresets();
  }

  Future<void> deletePreset(String id) async {
    await _datasource.deletePreset(id);
    await _loadPresets();
  }

  List<Preset> getBuiltInPresets() {
    return state.valueOrNull?.where((p) => p.isBuiltIn).toList() ?? [];
  }

  List<Preset> getCustomPresets() {
    return state.valueOrNull?.where((p) => !p.isBuiltIn).toList() ?? [];
  }

  List<Preset> getPresetsByCategory(PresetCategory category) {
    return state.valueOrNull?.where((p) => p.category == category).toList() ??
        [];
  }
}
