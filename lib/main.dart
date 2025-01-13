import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/inventory_page.dart'; // Import InventoryPage
import '../models/inventory_item.dart';
import 'screens/invoice_page.dart'; // Import InvoicePage
import '../models/invoice_model.dart';
import 'screens/quotation_page.dart'; // Import InvoicePage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(InventoryItemAdapter());
  Hive.registerAdapter(InvoiceItemAdapter());
  Hive.registerAdapter(InvoiceAdapter());

  await Hive.openBox<InventoryItem>('inventory');
  await Hive.openBox<Invoice>('invoice'); // Fix the type here
  runApp(const ERPApp());
}


class ERPApp extends StatelessWidget {
  const ERPApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KARAN TECH'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.asset(
                'lib/assets/logo.png', // Ensure the image exists in assets folder
                height: 230,
              ),
            ),
            const SizedBox(height: 20),
            // Buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InventoryPage()),
                );
              },
              child: const Text('Manage Inventory'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InvoicePage()),
                );
              },
              child: const Text('Create Invoice'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QuotationPage()),
                );
              },
              child: const Text('Create Quotation'),
            ),
          ],
        ),
      ),
    );
  }
}


