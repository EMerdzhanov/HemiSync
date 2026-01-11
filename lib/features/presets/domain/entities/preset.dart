import 'package:equatable/equatable.dart';
import '../../../audio_engine/domain/entities/waveform_type.dart';

enum PresetCategory {
  sleep('Sleep', 'Delta waves for deep sleep'),
  meditation('Meditation', 'Theta waves for meditation'),
  relaxation('Relaxation', 'Alpha waves for relaxation'),
  focus('Focus', 'Beta waves for concentration'),
  energy('Energy', 'Gamma waves for peak awareness'),
  custom('Custom', 'User-created preset');

  const PresetCategory(this.displayName, this.description);

  final String displayName;
  final String description;
}

class Preset extends Equatable {
  const Preset({
    required this.id,
    required this.name,
    this.description,
    required this.leftFrequency,
    required this.rightFrequency,
    this.waveform = WaveformType.sine,
    this.defaultDuration = const Duration(minutes: 15),
    this.category = PresetCategory.custom,
    this.isBuiltIn = false,
    required this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String? description;
  final double leftFrequency;
  final double rightFrequency;
  final WaveformType waveform;
  final Duration defaultDuration;
  final PresetCategory category;
  final bool isBuiltIn;
  final DateTime createdAt;
  final DateTime? updatedAt;

  double get binauralBeat => (leftFrequency - rightFrequency).abs();

  Preset copyWith({
    String? id,
    String? name,
    String? description,
    double? leftFrequency,
    double? rightFrequency,
    WaveformType? waveform,
    Duration? defaultDuration,
    PresetCategory? category,
    bool? isBuiltIn,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Preset(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      leftFrequency: leftFrequency ?? this.leftFrequency,
      rightFrequency: rightFrequency ?? this.rightFrequency,
      waveform: waveform ?? this.waveform,
      defaultDuration: defaultDuration ?? this.defaultDuration,
      category: category ?? this.category,
      isBuiltIn: isBuiltIn ?? this.isBuiltIn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        leftFrequency,
        rightFrequency,
        waveform,
        defaultDuration,
        category,
        isBuiltIn,
        createdAt,
        updatedAt,
      ];
}
