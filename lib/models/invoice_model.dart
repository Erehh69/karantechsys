import 'package:hive/hive.dart';
import 'inventory_item.dart';

part 'invoice_model.g.dart';

@HiveType(typeId: 1)
class Invoice extends HiveObject {
  @HiveField(0)
  late String companyName;

  @HiveField(1)
  late String companyAddress;

  @HiveField(2)
  late String companyEmail;

  @HiveField(3)
  late String payTo;

  @HiveField(4)
  late String accountName;

  @HiveField(5)
  late String accountNumber;

  @HiveField(6)
  late DateTime date;

  @HiveField(7)
  late List<InvoiceItem> items;

  @HiveField(8)
  late String id; // Unique identifier

  Invoice({
    required this.companyName,
    required this.companyAddress,
    required this.companyEmail,
    required this.payTo,
    required this.accountName,
    required this.accountNumber,
    required this.date,
    required this.items,
  }) : id = DateTime.now().millisecondsSinceEpoch.toString(); // Auto-generate ID
}


@HiveType(typeId: 2)
class InvoiceItem extends HiveObject {
  @HiveField(0)
  final InventoryItem item;

  @HiveField(1)
  int quantity;

  InvoiceItem({
    required this.item,
    required this.quantity,
  });

  double get total => quantity * item.unitPrice;
}
