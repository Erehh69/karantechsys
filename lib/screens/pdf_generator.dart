import 'dart:io';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/invoice_model.dart';
import '../models/quotation_model.dart';

Future<void> generateInvoicePdf(Invoice invoice) async {
  final pdf = pw.Document();

  // Load the logo as a byte array
  final logoBytes = await rootBundle.load('lib/assets/KARAN.png');
  final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Invoice',
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                    width: 100,
                    height: 100,
                    child: pw.Image(logo, fit: pw.BoxFit.cover),
                  ),
                ],
              ),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Company and Bank Details
              pw.Text('Company Details', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 5),
              pw.Text('Company Name: ${invoice.companyName}'),
              pw.Text('Address: ${invoice.companyAddress}'),
              pw.Text('Email: ${invoice.companyEmail}'),
              pw.SizedBox(height: 10),
              pw.Text('Bill To', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('Bank/Cash: ${invoice.payTo}'),
              pw.Text('Account Name: ${invoice.accountName}'),
              pw.Text('Account Number: ${invoice.accountNumber}'),
              pw.SizedBox(height: 20),

              // Invoice Date
              pw.Text(
                'Invoice Date: ${invoice.date.toLocal()}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 20),

              // Items Table
              pw.Table.fromTextArray(
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                cellStyle: pw.TextStyle(fontSize: 12),
                cellAlignment: pw.Alignment.centerLeft,
                data: [
                  ['Item/Service', 'Quantity', 'Unit Price', 'Total'],
                  ...invoice.items.map((item) => [
                    item.item.name,
                    item.quantity.toString(),
                    'RM ${item.item.unitPrice.toStringAsFixed(2)}',
                    'RM ${item.total.toStringAsFixed(2)}',
                  ]),
                ],
              ),
              pw.Divider(),
              pw.Text(
                'Total: RM ${invoice.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
            ],
          ),
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/invoice.pdf');

  await file.writeAsBytes(await pdf.save());
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice.pdf');
}

Future<void> generateQuotationPdf(Quotation quotation) async {
  final pdf = pw.Document();

  // Load the logo as a byte array
  final logoBytes = await rootBundle.load('lib/assets/KARAN.png');
  final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Quotation',
                    style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Container(
                    width: 100,
                    height: 100,
                    child: pw.Image(logo, fit: pw.BoxFit.cover),
                  ),
                ],
              ),
              pw.Divider(thickness: 1),
              pw.SizedBox(height: 10),

              // Company & Client Details
              pw.Text('Company Details', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('Company Name: ${quotation.companyName}'),
              pw.Text('Address: ${quotation.companyAddress}'),
              pw.Text('Email: ${quotation.companyEmail}'),
              pw.SizedBox(height: 10),
              pw.Text('Client Details', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              pw.Text('Name: ${quotation.clientName}'),
              pw.Text('Contact: ${quotation.clientContact}'),
              pw.SizedBox(height: 20),

              // Quotation Date
              pw.Text(
                'Quotation Date: ${quotation.date.toLocal()}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 20),

              // Items Table
              pw.Table.fromTextArray(
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
                cellStyle: pw.TextStyle(fontSize: 12),
                cellAlignment: pw.Alignment.centerLeft,
                data: [
                  ['Item/Service', 'Quantity', 'Unit Price', 'Total'],
                  ...quotation.items.map((item) => [
                    item.item.name,
                    item.quantity.toString(),
                    'RM ${item.item.unitPrice.toStringAsFixed(2)}',
                    'RM ${item.total.toStringAsFixed(2)}',
                  ]),
                ],
              ),
              pw.Divider(),
              pw.Text(
                'Total: RM ${quotation.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.blue900),
              ),
            ],
          ),
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/quotation.pdf');

  await file.writeAsBytes(await pdf.save());
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'quotation.pdf');
}
