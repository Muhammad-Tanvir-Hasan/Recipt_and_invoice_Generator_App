import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> generateInvoicePdf({
  required String customerName,
  required String invoiceNumber,
  required DateTime invoiceDate,
  required DateTime dueDate,
  required List<Map<String, dynamic>> items,
  required double totalAmount,
}) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 16),
            pw.Text('Customer Name: $customerName'),
            pw.Text('Invoice Number: $invoiceNumber'),
            pw.Text('Invoice Date: ${invoiceDate.toString().split(' ')[0]}'),
            pw.Text('Due Date: ${dueDate.toString().split(' ')[0]}'),
            pw.SizedBox(height: 24),
            pw.Text('Items', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 8),
            pw.Table.fromTextArray(
              headers: ['Item', 'Quantity', 'Price', 'Total'],
              data: items.map((item) {
                return [
                  item['name'],
                  item['quantity'].toString(),
                  '\$${item['price'].toStringAsFixed(2)}',
                  '\$${(item['price'] * item['quantity']).toStringAsFixed(2)}',
                ];
              }).toList(),
            ),
            pw.Divider(),
            pw.Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
          ],
        );
      },
    ),
  );

  return pdf.save();
}
