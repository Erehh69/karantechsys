import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../models/invoice_model.dart';

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
            pw.Text('Pay To: ${invoice.payTo}'),
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
              'Total: ${invoice.items.fold(0.0, (sum, item) => sum + item.total).toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
          ],
        );
      },
    ),
  );

  // Get the temporary directory
  final output = await getTemporaryDirectory();
  final file = File('${output.path}/invoice.pdf');

  // Save the PDF file
  await file.writeAsBytes(await pdf.save());

  // Share the PDF file
  await Printing.sharePdf(
    bytes: await pdf.save(),
    filename: 'invoice.pdf',
  );
}
