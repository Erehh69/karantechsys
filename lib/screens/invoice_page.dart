import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/invoice_model.dart';
import 'create_invoice_page.dart'; // Import CreateInvoicePage
import 'pdf_generator.dart'; // Import the PDF generator

class InvoicePage extends StatelessWidget {
  const InvoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Management'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Invoice>('invoice').listenable(),
        builder: (context, Box<Invoice> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No invoices available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final invoice = box.getAt(index);
              return ListTile(
                title: Text(invoice?.companyName ?? 'Unknown'),
                subtitle: Text(
                  'Total: \RM${invoice?.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                ),
                onTap: () async {
                  if (invoice != null) {
                    await generateInvoicePdf(invoice); // Use the shared PDF generator
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateInvoicePage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
