import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quotation_model.dart';
import '../models/inventory_item.dart';

class CreateQuotationPage extends StatefulWidget {
  const CreateQuotationPage({super.key});

  @override
  _CreateQuotationPageState createState() => _CreateQuotationPageState();
}

class _CreateQuotationPageState extends State<CreateQuotationPage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientContactController = TextEditingController();
  final List<QuotationItem> _items = [];
  final Box<InventoryItem> _inventoryBox = Hive.box<InventoryItem>('inventory');

  // Add an item to the quotation from inventory
  void _addItem(InventoryItem item) {
    final existingItem = _items.firstWhere(
          (entry) => entry.item.name == item.name,
      orElse: () => QuotationItem(
        item: item,
        quantity: 0,
        total: 0,
      ),
    );

    if (_items.contains(existingItem)) {
      final updatedItem = existingItem.withUpdatedQuantity(existingItem.quantity + 1);
      final index = _items.indexOf(existingItem);
      _items[index] = updatedItem;
    } else {
      _items.add(
        QuotationItem(
          item: item,
          quantity: 1,
          total: item.unitPrice,
        ),
      );
    }

    setState(() {});
  }

  // Save the quotation
  void _saveQuotation() async {
    if (_formKey.currentState!.validate()) {
      final quotation = Quotation(
        companyName: _companyNameController.text,
        companyAddress: _companyAddressController.text,
        companyEmail: _companyEmailController.text,
        clientName: _clientNameController.text,
        clientContact: _clientContactController.text,
        date: DateTime.now(),
        items: _items,
      );

      Hive.box<Quotation>('quotation').add(quotation);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quotation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a company name' : null,
              ),
              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(labelText: 'Company Address'),
                validator: (value) => value!.isEmpty ? 'Please enter a company address' : null,
              ),
              TextFormField(
                controller: _companyEmailController,
                decoration: const InputDecoration(labelText: 'Company Email'),
                validator: (value) => value!.isEmpty ? 'Please enter a company email' : null,
              ),
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a client name' : null,
              ),
              TextFormField(
                controller: _clientContactController,
                decoration: const InputDecoration(labelText: 'Client Contact'),
                validator: (value) => value!.isEmpty ? 'Please enter a client contact' : null,
              ),
              const SizedBox(height: 16.0),
              const Text('Select Items from Inventory'),
              ValueListenableBuilder(
                valueListenable: _inventoryBox.listenable(),
                builder: (context, Box<InventoryItem> box, _) {
                  if (box.isEmpty) {
                    return const Text('No items in inventory');
                  }
                  return DropdownButton<InventoryItem>(
                    isExpanded: true,
                    hint: const Text('Select Item'),
                    items: box.values.map((item) {
                      return DropdownMenuItem<InventoryItem>(
                        value: item,
                        child: Text(item.name),
                      );
                    }).toList(),
                    onChanged: (item) {
                      if (item != null) {
                        _addItem(item);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Items (${_items.length}):',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              ..._items.map(
                    (item) => ListTile(
                  title: Text(item.item.name),
                  subtitle: Text('Quantity: ${item.quantity}, Total: \RM${item.total.toStringAsFixed(2)}'),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _saveQuotation,
                child: const Text('Save Quotation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
