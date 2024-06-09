import 'package:flutter/material.dart';
import 'company_information.dart';
import 'generate_receipt.dart'; // Import the GenerateReceiptPage
import 'generate_invoice.dart'; // Import the InvoiceGenerationPage

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DashboardPage(),
  ),
);

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade800,
              Colors.green.shade400
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  Text(
                    "Dashboard",
                    style: TextStyle(color: Colors.white, fontSize: 40),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Welcome to Your Dashboard",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      _buildDashboardItem("Generate Invoice", () {
                        // Navigate to the InvoiceGenerationPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InvoiceGenerationPage()),
                        );
                      }),
                      _buildDashboardItem("Generate Receipt", () {
                        // Navigate to the GenerateReceiptPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GenerateReceiptPage()),
                        );
                      }),
                      _buildDashboardItem("Company Information", () {
                        // Handle "Company Information" button press
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CompanyInformationPage()),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardItem(String title, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(225, 95, 27, .3),
              blurRadius: 20,
              offset: Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}