import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/inventory_item_model.dart';

class InventoryPage extends StatefulWidget {
  @override
  _InventoryPageState createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  final DBHelper _dbHelper = DBHelper();
  List<InventoryItem> _inventory = [];

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    final data = await _dbHelper.getData('inventory');
    setState(() {
      _inventory = data.map((item) => InventoryItem.fromMap(item)).toList();
    });
  }

  Future<void> _addItem(InventoryItem item) async {
    await _dbHelper.insert('inventory', item.toMap());
    _fetchInventory();
  }

  Future<void> _updateItem(InventoryItem item) async {
    await _dbHelper.update('inventory', item.toMap(), item.id!);
    _fetchInventory();
  }

  Future<void> _deleteItem(int id) async {
    await _dbHelper.delete('inventory', id);
    _fetchInventory();
  }

  void _showForm({InventoryItem? item}) {
    final _nameController = TextEditingController(text: item?.name ?? '');
    final _quantityController = TextEditingController(
        text: item != null ? item.quantity.toString() : '');
    final _priceController = TextEditingController(
        text: item != null ? item.price.toString() : '');

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Item Name'),
            ),
            TextField(
              controller: _quantityController,
              decoration: InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final newItem = InventoryItem(
                  id: item?.id,
                  name: _nameController.text,
                  quantity: int.tryParse(_quantityController.text) ?? 0,
                  price: double.tryParse(_priceController.text) ?? 0.0,
                );
                if (item == null) {
                  _addItem(newItem);
                } else {
                  _updateItem(newItem);
                }
                Navigator.pop(context);
              },
              child: Text(item == null ? 'Add Item' : 'Update Item'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory'),
      ),
      body: _inventory.isEmpty
          ? Center(child: Text('No items in inventory'))
          : ListView.builder(
        itemCount: _inventory.length,
        itemBuilder: (context, index) {
          final item = _inventory[index];
          return ListTile(
            title: Text(item.name),
            subtitle:
            Text('Quantity: ${item.quantity}, Price: \$${item.price}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showForm(item: item),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteItem(item.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showForm(),
      ),
    );
  }
}
