import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart'; // Import the Login.dart file

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool _agreeTerms = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _createAccount(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Store additional user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        // You can add more user data here
      });

      // Navigate to the login screen after successful account creation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SignInPage()), // Replace LoginScreen with the appropriate screen
      );
    } catch (e) {
      // Handle signup errors
      print("Error creating account: $e");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to create account. Please try again."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 34, 223),
        title: Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Container(
        height:800,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 83, 34, 223), Color.fromARGB(255, 204, 187, 250)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _nameController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your name *",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _emailController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your email *",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Enter your password *",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Re-enter your password *",
                          border: InputBorder.none,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please re-enter your password';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Checkbox(
                        value: _agreeTerms,
                        onChanged: (value) {
                          setState(() {
                            _agreeTerms = value ?? false;
                          });
                        },
                      ),
                      Text(
                        "I agree with terms of service and privacy policy",
                        style: TextStyle(
                            color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _createAccount(
                            context); // Create account and redirect to Login page if successful
                      }
                    },
                    child: Text("Create Account"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
