import 'package:hive/hive.dart';

part 'inventory_item.g.dart';

@HiveType(typeId: 0)
class InventoryItem extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late int quantity;

  @HiveField(2)
  late double unitPrice;

  @HiveField(3)
  late String description; // Optional field for item details

  InventoryItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.description = '',
  });
}
