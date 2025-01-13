// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceAdapter extends TypeAdapter<Invoice> {
  @override
  final int typeId = 1;

  @override
  Invoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Invoice(
      companyName: fields[0] as String,
      companyAddress: fields[1] as String,
      companyEmail: fields[2] as String,
      payTo: fields[3] as String,
      accountName: fields[4] as String,
      accountNumber: fields[5] as String,
      date: fields[6] as DateTime,
      items: (fields[7] as List).cast<InvoiceItem>(),
    )..id = fields[8] as String;
  }

  @override
  void write(BinaryWriter writer, Invoice obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.companyName)
      ..writeByte(1)
      ..write(obj.companyAddress)
      ..writeByte(2)
      ..write(obj.companyEmail)
      ..writeByte(3)
      ..write(obj.payTo)
      ..writeByte(4)
      ..write(obj.accountName)
      ..writeByte(5)
      ..write(obj.accountNumber)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.items)
      ..writeByte(8)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InvoiceItemAdapter extends TypeAdapter<InvoiceItem> {
  @override
  final int typeId = 2;

  @override
  InvoiceItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceItem(
      item: fields[0] as InventoryItem,
      quantity: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
