import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart'; // Import printing package
import 'receipt_generatePdf.dart'; // Import your PDF generation file

class GenerateReceiptPage extends StatefulWidget {
  const GenerateReceiptPage({Key? key}) : super(key: key);

  @override
  _GenerateReceiptPageState createState() => _GenerateReceiptPageState();
}

class _GenerateReceiptPageState extends State<GenerateReceiptPage> {
  final List<Map<String, dynamic>> _items = [];
  double _totalAmount = 0.0;

  // Customer and receipt details
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _receiptNumberController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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

  Future<void> _printReceipt() async {
    final pdfData = await generatePdf(
      customerName: _customerNameController.text,
      receiptNumber: _receiptNumberController.text,
      receiptDate: _selectedDate,
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
        title: const Text('Receipt Generator'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Generate Receipt',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Customer Name', Icons.person, _customerNameController),
            _buildTextField('Receipt Number', Icons.receipt, _receiptNumberController),
            _buildDateField('Receipt Date', Icons.calendar_today),
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
            ..._items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildItemRow(index, item);
            }).toList(),
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
                onPressed: _printReceipt,
                child: const Text('Generate Receipt'),
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

  Widget _buildTextField(String label, IconData prefixIcon, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Colors.teal),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, IconData prefixIcon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Colors.teal),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
        readOnly: true,
        onTap: () async {
          final selectedDate = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (selectedDate != null) {
            setState(() {
              _selectedDate = selectedDate;
            });
          }
        },
      ),
    );
  }

  Widget _buildItemRow(int index, Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Item ${index + 1}',
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  item['name'] = value;
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  item['quantity'] = int.tryParse(value) ?? 1;
                  _calculateTotalAmount();
                });
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _updateItemPrice(index, double.tryParse(value) ?? 0.0);
              },
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.red,
            onPressed: () => _removeItem(index),
          ),
        ],
      ),
    );
  }
}
