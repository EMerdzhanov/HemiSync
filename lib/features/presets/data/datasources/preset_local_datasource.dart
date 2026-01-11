import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/constants/built_in_presets.dart';
import '../../domain/entities/preset.dart';
import '../models/preset_model.dart';

class PresetLocalDatasource {
  static const String _boxName = 'presets';
  Box<PresetModel>? _box;

  Future<void> initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(PresetModelAdapter());
    _box = await Hive.openBox<PresetModel>(_boxName);

    // Seed built-in presets if first run
    if (_box!.isEmpty) {
      await _seedBuiltInPresets();
    }
  }

  Future<void> _seedBuiltInPresets() async {
    for (final preset in builtInPresets) {
      await _box!.put(preset.id, PresetModel.fromEntity(preset));
    }
  }

  Future<List<Preset>> getAllPresets() async {
    if (_box == null) await initialize();
    return _box!.values.map((model) => model.toEntity()).toList();
  }

  Future<List<Preset>> getBuiltInPresets() async {
    final all = await getAllPresets();
    return all.where((p) => p.isBuiltIn).toList();
  }

  Future<List<Preset>> getCustomPresets() async {
    final all = await getAllPresets();
    return all.where((p) => !p.isBuiltIn).toList();
  }

  Future<List<Preset>> getPresetsByCategory(PresetCategory category) async {
    final all = await getAllPresets();
    return all.where((p) => p.category == category).toList();
  }

  Future<Preset?> getPresetById(String id) async {
    if (_box == null) await initialize();
    final model = _box!.get(id);
    return model?.toEntity();
  }

  Future<void> savePreset(Preset preset) async {
    if (_box == null) await initialize();
    await _box!.put(preset.id, PresetModel.fromEntity(preset));
  }

  Future<void> deletePreset(String id) async {
    if (_box == null) await initialize();
    // Don't allow deleting built-in presets
    final preset = _box!.get(id);
    if (preset != null && !preset.isBuiltIn) {
      await _box!.delete(id);
    }
  }

  Future<void> close() async {
    await _box?.close();
  }
}
