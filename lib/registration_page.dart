import 'package:flutter/material.dart';
import 'signup_success_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _reEnterPasswordController = TextEditingController();

  Map<String, bool> fieldStatus = {
    'Full Name': false,
    'Email': false,
    'Password': false,
    'Re-enter Password': false,
    'Gender': false,
    'Date of Birth': false,
    'Company Name': false,
    'Contact Info': false,
  };

  Color signUpButtonColor = Colors.grey; // Initial color for the button

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade800,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          buildTextField("Full Name", 'Full Name', Icons.person),
                          buildTextField("Email", 'Email', Icons.email),
                          buildTextField("Password", 'Password', Icons.lock),
                          buildTextField("Re-enter Password", 'Re-enter Password', Icons.lock),
                          buildTextField("Gender", 'Gender', Icons.person),
                          buildTextField("Date of Birth", 'Date of Birth', Icons.calendar_today),
                          buildTextField("Company Name", 'Company Name', Icons.business),
                          buildTextField("Contact Info", 'Contact Info', Icons.phone),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  MaterialButton(
                    onPressed: () {
                      if (checkAllFieldsFilled()) {
                        // Navigate to the signup success page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignupSuccessPage()),
                        );
                      } else {
                        // Display red dots for unfilled options
                        setState(() {
                          fieldStatus = Map.fromEntries(
                            fieldStatus.entries.map((entry) => MapEntry(entry.key, entry.value)),
                          );
                        });
                      }
                    },
                    height: 50,
                    minWidth: 200,
                    color: signUpButtonColor, // Set the color dynamically
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String hintText, String fieldName, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        onChanged: (value) {
          // Update the field status when the user starts typing
          setState(() {
            fieldStatus[fieldName] = value.isEmpty;
          });

          // Update the button color dynamically
          updateSignUpButtonColor();
        },
        obscureText: hintText == 'Password' || hintText == 'Re-enter Password',
        controller: hintText == 'Re-enter Password' ? _reEnterPasswordController : null,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(20),
          ),
          suffixIcon: fieldStatus[fieldName] ?? false
              ? const Icon(Icons.error, color: Colors.red)
              : null,
        ),
      ),
    );
  }

  void updateSignUpButtonColor() {
    if (checkAllFieldsFilled()) {
      setState(() {
        signUpButtonColor = Colors.blue.shade600; // Change button color to blue
      });
    } else {
      setState(() {
        signUpButtonColor = Colors.grey; // Change button color to grey
      });
    }
  }

  bool checkAllFieldsFilled() {
    return fieldStatus.values.every((filled) => !filled);
  }
}