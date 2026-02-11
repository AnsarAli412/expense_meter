// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetConfigAdapter extends TypeAdapter<BudgetConfig> {
  @override
  final int typeId = 7;

  @override
  BudgetConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BudgetConfig(
      needsPercentage: fields[0] as double,
      wantsPercentage: fields[1] as double,
      savingsPercentage: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BudgetConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.needsPercentage)
      ..writeByte(1)
      ..write(obj.wantsPercentage)
      ..writeByte(2)
      ..write(obj.savingsPercentage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
