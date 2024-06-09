import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'invoice_generatePdf.dart'; // Import the PDF generation file

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: InvoiceGenerationPage(),
  ),
);

class InvoiceGenerationPage extends StatefulWidget {
  const InvoiceGenerationPage({Key? key}) : super(key: key);

  @override
  _InvoiceGenerationPageState createState() => _InvoiceGenerationPageState();
}

class _InvoiceGenerationPageState extends State<InvoiceGenerationPage> {
  final List<Map<String, dynamic>> _items = [];
  double _totalAmount = 0.0;
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _invoiceNumberController = TextEditingController();
  final TextEditingController _invoiceDateController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();

  void _addItem() {
    setState(() {
      _items.add({
        'name': '',
        'quantity': 1,
        'price': 0.0,
      });
    });
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _calculateTotalAmount();
    });
  }

  void _updateItemPrice(int index, double price) {
    setState(() {
      _items[index]['price'] = price;
      _calculateTotalAmount();
    });
  }

  void _calculateTotalAmount() {
    _totalAmount = _items.fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        controller.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _generateAndPrintInvoice() async {
    final pdfData = await generateInvoicePdf(
      customerName: _customerNameController.text,
      invoiceNumber: _invoiceNumberController.text,
      invoiceDate: DateTime.parse(_invoiceDateController.text),
      dueDate: DateTime.parse(_dueDateController.text),
      items: _items,
      totalAmount: _totalAmount,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Generator'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Invoice',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _customerNameController,
              decoration: const InputDecoration(
                labelText: 'Customer Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _invoiceNumberController,
              decoration: const InputDecoration(
                labelText: 'Invoice Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _invoiceDateController,
              decoration: InputDecoration(
                labelText: 'Invoice Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _invoiceDateController),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _dueDateController,
              decoration: InputDecoration(
                labelText: 'Due Date',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context, _dueDateController),
                ),
              ),
              readOnly: true,
            ),
            const SizedBox(height: 24),
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _items[index]['name'] = value;
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Item Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _items[index]['quantity'] = int.tryParse(value) ?? 1;
                            _calculateTotalAmount();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _items[index]['price'] = double.tryParse(value) ?? 0.0;
                            _calculateTotalAmount();
                          });
                        },
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _removeItem(index),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.teal,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Total Amount: \$$_totalAmount',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: _generateAndPrintInvoice,
                child: const Text('Generate & Print Invoice'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.teal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}