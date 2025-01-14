import 'package:hive/hive.dart';
import 'inventory_item.dart';

part 'quotation_model.g.dart'; // Hive generator

@HiveType(typeId: 3) // Unique typeId for Hive adapter
class Quotation extends HiveObject {
  @HiveField(0)
  final String companyName;

  @HiveField(1)
  final String companyAddress;

  @HiveField(2)
  final String companyEmail;

  @HiveField(3)
  final String clientName;

  @HiveField(4)
  final String clientContact;

  @HiveField(5)
  final DateTime date;

  @HiveField(6)
  final List<QuotationItem> items;

  Quotation({
    required this.companyName,
    required this.companyAddress,
    required this.companyEmail,
    required this.clientName,
    required this.clientContact,
    required this.date,
    required this.items,
  });
}

@HiveType(typeId: 4) // Unique typeId for Hive adapter
class QuotationItem {
  @HiveField(0)
  final InventoryItem item;

  @HiveField(1)
  final int quantity;

  @HiveField(2)
  final double total;

  QuotationItem({
    required this.item,
    required this.quantity,
    required this.total,
  });

  // Add a method to update the quantity
  QuotationItem withUpdatedQuantity(int newQuantity) {
    return QuotationItem(
      item: this.item,
      quantity: newQuantity,
      total: this.item.unitPrice * newQuantity,
    );
  }
}
