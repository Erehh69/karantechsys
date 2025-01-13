import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import '../models/inventory_item.dart';
import 'package:hive/hive.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _unitPriceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final Box<InventoryItem> _inventoryBox = Hive.box<InventoryItem>('inventory');

  void _addItem() {
    final name = _nameController.text.trim();
    final quantity = int.tryParse(_quantityController.text) ?? 0;
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0.0;
    final description = _descriptionController.text.trim();

    if (name.isNotEmpty && quantity > 0 && unitPrice > 0) {
      final newItem = InventoryItem(
        name: name,
        quantity: quantity,
        unitPrice: unitPrice,
        description: description,
      );
      _inventoryBox.add(newItem);

      _nameController.clear();
      _quantityController.clear();
      _unitPriceController.clear();
      _descriptionController.clear();

      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item "$name" added to inventory!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields correctly.')),
      );
    }
  }

  void _deleteItem(int index) {
    _inventoryBox.deleteAt(index);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item deleted from inventory.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Inventory')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _unitPriceController,
              decoration: const InputDecoration(labelText: 'Unit Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addItem,
              child: const Text('Add Item'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: _inventoryBox.listenable(),
                builder: (context, Box<InventoryItem> box, _) {
                  if (box.isEmpty) {
                    return const Center(child: Text('No items in inventory'));
                  }
                  return ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final item = box.getAt(index);
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          title: Text(item!.name),
                          subtitle: Text(
                            'Price: ${item.unitPrice.toStringAsFixed(2)} | Qty: ${item.quantity}\nDescription: ${item.description}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteItem(index),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
