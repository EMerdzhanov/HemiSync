import 'package:hive/hive.dart';
import '../../../audio_engine/domain/entities/waveform_type.dart';
import '../../domain/entities/preset.dart';

part 'preset_model.g.dart';

@HiveType(typeId: 0)
class PresetModel extends HiveObject {
  PresetModel({
    required this.id,
    required this.name,
    this.description,
    required this.leftFrequency,
    required this.rightFrequency,
    required this.waveformIndex,
    required this.durationSeconds,
    required this.categoryIndex,
    required this.isBuiltIn,
    required this.createdAt,
    this.updatedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final double leftFrequency;

  @HiveField(4)
  final double rightFrequency;

  @HiveField(5)
  final int waveformIndex;

  @HiveField(6)
  final int durationSeconds;

  @HiveField(7)
  final int categoryIndex;

  @HiveField(8)
  final bool isBuiltIn;

  @HiveField(9)
  final DateTime createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  Preset toEntity() => Preset(
        id: id,
        name: name,
        description: description,
        leftFrequency: leftFrequency,
        rightFrequency: rightFrequency,
        waveform: WaveformType.values[waveformIndex],
        defaultDuration: Duration(seconds: durationSeconds),
        category: PresetCategory.values[categoryIndex],
        isBuiltIn: isBuiltIn,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  factory PresetModel.fromEntity(Preset preset) => PresetModel(
        id: preset.id,
        name: preset.name,
        description: preset.description,
        leftFrequency: preset.leftFrequency,
        rightFrequency: preset.rightFrequency,
        waveformIndex: preset.waveform.index,
        durationSeconds: preset.defaultDuration.inSeconds,
        categoryIndex: preset.category.index,
        isBuiltIn: preset.isBuiltIn,
        createdAt: preset.createdAt,
        updatedAt: preset.updatedAt,
      );
}
