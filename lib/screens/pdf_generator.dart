import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/invoice_model.dart';
import '../models/quotation_model.dart'; // Import Quotation model

Future<void> generateInvoicePdf(Invoice invoice) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Company Name: ${invoice.companyName}'),
            pw.Text('Address: ${invoice.companyAddress}'),
            pw.Text('Email: ${invoice.companyEmail}'),
            pw.SizedBox(height: 20),
            pw.Text('Bank: ${invoice.payTo}'),
            pw.Text('Account Name: ${invoice.accountName}'),
            pw.Text('Account Number: ${invoice.accountNumber}'),
            pw.SizedBox(height: 20),
            pw.Text('Date: ${invoice.date.toLocal()}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['Item', 'Quantity', 'Unit Price', 'Total'],
                ...invoice.items.map((item) => [
                  item.item.name,
                  item.quantity.toString(),
                  item.item.unitPrice.toString(),
                  item.total.toString()
                ])
              ],
            ),
            pw.Divider(),
            pw.Text(
              'Total: RM ${invoice.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/invoice.pdf');

  await file.writeAsBytes(await pdf.save());

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'invoice.pdf',
  );
}

Future<void> generateQuotationPdf(Quotation quotation) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Quotation', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Company Name: ${quotation.companyName}'),
            pw.Text('Address: ${quotation.companyAddress}'),
            pw.Text('Email: ${quotation.companyEmail}'),
            pw.SizedBox(height: 20),
            pw.Text('Prepared For: ${quotation.clientName}'),
            pw.Text('Contact: ${quotation.clientContact}'),
            pw.SizedBox(height: 20),
            pw.Text('Date: ${quotation.date.toLocal()}'),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              data: [
                ['Item', 'Quantity', 'Unit Price', 'Total'],
                ...quotation.items.map((item) => [
                  item.item.name,
                  item.quantity.toString(),
                  item.item.unitPrice.toString(),
                  item.total.toString()
                ])
              ],
            ),
            pw.Divider(),
            pw.Text(
              'Total: RM ${quotation.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        );
      },
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/quotation.pdf');

  await file.writeAsBytes(await pdf.save());

  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'quotation.pdf',
  );
}
