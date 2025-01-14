import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/quotation_model.dart'; // Import the Quotation model
import 'create_quotation_page.dart'; // Import the CreateQuotationPage
import 'pdf_generator.dart'; // Import the PDF generator

class QuotationPage extends StatelessWidget {
  const QuotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation Management'),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Quotation>('quotation').listenable(),
        builder: (context, Box<Quotation> box, _) {
          if (box.isEmpty) {
            return const Center(child: Text('No quotations available.'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final quotation = box.getAt(index);
              return ListTile(
                title: Text(quotation?.companyName ?? 'Unknown'),
                subtitle: Text(
                  'Total: \RM${quotation?.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                ),
                onTap: () async {
                  if (quotation != null) {
                    await generateQuotationPdf(quotation); // Use the shared PDF generator
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
            MaterialPageRoute(builder: (context) => const CreateQuotationPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
