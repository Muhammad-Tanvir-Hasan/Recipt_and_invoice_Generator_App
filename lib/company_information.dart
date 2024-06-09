import 'package:flutter/material.dart';

class CompanyInformationPage extends StatefulWidget {
  const CompanyInformationPage({Key? key}) : super(key: key);

  @override
  _CompanyInformationPageState createState() => _CompanyInformationPageState();
}

class _CompanyInformationPageState extends State<CompanyInformationPage> {
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Information'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Company Information',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Company Name', Icons.business, _companyNameController),
            _buildTextField('Address', Icons.location_on, _addressController),
            _buildTextField('Contact', Icons.phone, _contactController),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle save company information
                  print('Company Name: ${_companyNameController.text}');
                  print('Address: ${_addressController.text}');
                  print('Contact: ${_contactController.text}');
                },
                child: const Text('Save Information'),
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
}