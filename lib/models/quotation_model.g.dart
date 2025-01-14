// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quotation_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuotationAdapter extends TypeAdapter<Quotation> {
  @override
  final int typeId = 3;

  @override
  Quotation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quotation(
      companyName: fields[0] as String,
      companyAddress: fields[1] as String,
      companyEmail: fields[2] as String,
      clientName: fields[3] as String,
      clientContact: fields[4] as String,
      date: fields[5] as DateTime,
      items: (fields[6] as List).cast<QuotationItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quotation obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.companyAddress)
      ..writeByte(2)
      ..write(obj.companyEmail)
      ..writeByte(3)
      ..write(obj.clientName)
      ..writeByte(4)
      ..write(obj.clientContact)
      ..writeByte(5)
      ..write(obj.date)
      ..writeByte(6)
      ..write(obj.items);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuotationItemAdapter extends TypeAdapter<QuotationItem> {
  @override
  final int typeId = 4;

  @override
  QuotationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuotationItem(
      item: fields[0] as InventoryItem,
      quantity: fields[1] as int,
      total: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, QuotationItem obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuotationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
