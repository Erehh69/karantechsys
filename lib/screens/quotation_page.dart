import 'package:flutter/material.dart';

class QuotationPage extends StatelessWidget {
  const QuotationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotation'),
      ),
      body: const Center(
        child: Text('Quotation Management Page'),
      ),
    );
  }
}
