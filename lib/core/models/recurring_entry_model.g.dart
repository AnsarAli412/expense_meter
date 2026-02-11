// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_entry_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecurringIntervalAdapter extends TypeAdapter<RecurringInterval> {
  @override
  final int typeId = 5;

  @override
  RecurringInterval read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RecurringInterval.monthly;
      case 1:
        return RecurringInterval.yearly;
      default:
        return RecurringInterval.monthly;
    }
  }

  @override
  void write(BinaryWriter writer, RecurringInterval obj) {
    switch (obj) {
      case RecurringInterval.monthly:
        writer.writeByte(0);
        break;
      case RecurringInterval.yearly:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringIntervalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecurringEntryAdapter extends TypeAdapter<RecurringEntry> {
  @override
  final int typeId = 6;

  @override
  RecurringEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecurringEntry(
      id: fields[0] as String,
      amount: fields[1] as double,
      type: fields[2] as TransactionType,
      categoryId: fields[3] as String?,
      subCategoryId: fields[4] as String?,
      interval: fields[5] as RecurringInterval,
      nextDueDate: fields[6] as DateTime,
      note: fields[7] as String?,
      source: fields[8] as String?,
      isActive: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RecurringEntry obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.categoryId)
      ..writeByte(4)
      ..write(obj.subCategoryId)
      ..writeByte(5)
      ..write(obj.interval)
      ..writeByte(6)
      ..write(obj.nextDueDate)
      ..writeByte(7)
      ..write(obj.note)
      ..writeByte(8)
      ..write(obj.source)
      ..writeByte(9)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurringEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
