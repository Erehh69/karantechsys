import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/inventory_page.dart'; // Import InventoryPage
import '../models/inventory_item.dart';
import 'screens/invoice_page.dart'; // Import InvoicePage
import '../models/invoice_model.dart';
import 'screens/quotation_page.dart'; // Import QuotationPage
import '../models/quotation_model.dart'; // Import QuotationModel

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(InventoryItemAdapter());
  Hive.registerAdapter(InvoiceItemAdapter());
  Hive.registerAdapter(InvoiceAdapter());
  Hive.registerAdapter(QuotationItemAdapter());
  Hive.registerAdapter(QuotationAdapter()); // Register the Quotation adapter

  // Open Hive boxes
  await Hive.openBox<InventoryItem>('inventory');
  await Hive.openBox<Invoice>('invoice');
  await Hive.openBox<Quotation>('quotation'); // Open the Quotation box

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
      // Apply the gradient background here
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.yellow], // Grey to Black gradient
            begin: Alignment.centerLeft, // Start gradient from left
            end: Alignment.centerRight, // End gradient on the right
          ),
        ),
        child: Center(
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
      ),
    );
  }
}
