import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/invoice_model.dart';
import '../models/inventory_item.dart';
import 'pdf_generator.dart';

class CreateInvoicePage extends StatefulWidget {
  const CreateInvoicePage({super.key});

  @override
  _CreateInvoicePageState createState() => _CreateInvoicePageState();
}

class _CreateInvoicePageState extends State<CreateInvoicePage> {
  final _formKey = GlobalKey<FormState>();
  final _companyNameController = TextEditingController();
  final _companyAddressController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _payToController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final List<InvoiceItem> _invoiceItems = [];
  final Box<InventoryItem> _inventoryBox = Hive.box<InventoryItem>('inventory');

  void _addItemToInvoice(InventoryItem item) {
    final existingItem = _invoiceItems.firstWhere(
          (entry) => entry.item == item,
      orElse: () => InvoiceItem(item: item, quantity: 0),
    );

    if (_invoiceItems.contains(existingItem)) {
      existingItem.quantity++;
    } else {
      _invoiceItems.add(existingItem..quantity = 1);
    }

    setState(() {});
  }

  double _calculateTotal() {
    return _invoiceItems.fold(0.0, (total, item) => total + item.total);
  }

  void _saveInvoice() async {
    if (_formKey.currentState!.validate()) {
      final invoice = Invoice(
        companyName: _companyNameController.text,
        companyAddress: _companyAddressController.text,
        companyEmail: _companyEmailController.text,
        payTo: _payToController.text,
        accountName: _accountNameController.text,
        accountNumber: _accountNumberController.text,
        date: DateTime.now(),
        items: _invoiceItems,
      );

      // Save to Hive
      final invoiceBox = Hive.box<Invoice>('invoice'); // Use already opened box
      await invoiceBox.add(invoice);

      // Generate PDF
      await generateInvoicePdf(invoice);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved and PDF generated successfully!')),
      );

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _companyNameController,
                decoration: const InputDecoration(labelText: 'Company Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _companyAddressController,
                decoration: const InputDecoration(labelText: 'Company Address'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _companyEmailController,
                decoration: const InputDecoration(labelText: 'Company Email'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const Divider(),
              TextFormField(
                controller: _payToController,
                decoration: const InputDecoration(labelText: 'Pay To'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _accountNameController,
                decoration: const InputDecoration(labelText: 'Account Name'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _accountNumberController,
                decoration: const InputDecoration(labelText: 'Account Number'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const Divider(),
              const Text(
                'Select Items from Inventory',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
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
                    onChanged: (item) => _addItemToInvoice(item!),
                  );
                },
              ),
              const SizedBox(height: 20),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _invoiceItems.length,
                itemBuilder: (context, index) {
                  final invoiceItem = _invoiceItems[index];
                  return ListTile(
                    title: Text('${invoiceItem.item.name} (x${invoiceItem.quantity})'),
                    subtitle: Text('Unit Price: ${invoiceItem.item.unitPrice.toStringAsFixed(2)}'),
                    trailing: Text('Total: ${invoiceItem.total.toStringAsFixed(2)}'),
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Grand Total: ${_calculateTotal().toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveInvoice,
                child: const Text('Save Invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
