part of 'preset_model.dart';

class PresetModelAdapter extends TypeAdapter<PresetModel> {
  @override
  final int typeId = 0;

  @override
  PresetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PresetModel(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String?,
      leftFrequency: fields[3] as double,
      rightFrequency: fields[4] as double,
      waveformIndex: fields[5] as int,
      durationSeconds: fields[6] as int,
      categoryIndex: fields[7] as int,
      isBuiltIn: fields[8] as bool,
      createdAt: fields[9] as DateTime,
      updatedAt: fields[10] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, PresetModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.leftFrequency)
      ..writeByte(4)
      ..write(obj.rightFrequency)
      ..writeByte(5)
      ..write(obj.waveformIndex)
      ..writeByte(6)
      ..write(obj.durationSeconds)
      ..writeByte(7)
      ..write(obj.categoryIndex)
      ..writeByte(8)
      ..write(obj.isBuiltIn)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PresetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
