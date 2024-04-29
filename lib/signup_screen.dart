

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechat/controllers/auth_controller.dart';
import 'package:mechat/controllers/add_user_data.dart';
import 'package:mechat/widgets/textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController languageController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    nameController.dispose();
    languageController.dispose();
    super.dispose();
  }

  bool isValidUsername(String username) {
    return RegExp(r'^[a-zA-Z\s]+$').hasMatch(username);  // Only alphabets
  }

  bool isValidPassword(String password) {
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\d]).{12,}$', // At least 12 characters with uppercase, lowercase, numbers, and symbols
    ).hasMatch(password);
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    AddUserData userData = Get.find();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 4, 1, 14),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 80),
            Text(
              'Create Account',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromARGB(255, 252, 251, 251),
              ),
            ),
            const SizedBox(height: 80),
            MyTextField(
              obscureText: false,
              controller: nameController,
              hint: 'Name',
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            MyTextField(
              obscureText: false,
              controller: emailController,
              hint: 'Email',
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            MyTextField(
              obscureText: true,
              controller: passwordController1,
              hint: 'Password',
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            MyTextField(
              obscureText: true,
              controller: passwordController2,
              hint: 'Confirm Password',
              color: Colors.white,
            ),
            const SizedBox(height: 15),
            MyTextField(
              obscureText: false,
              controller: languageController,
              hint: 'Language',
              color: Colors.white,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                // Username validation
                if (!isValidUsername(nameController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Username must contain only alphabets.'),
                    ),
                  );
                  return;
                }

                // Password validation
                if (!isValidPassword(passwordController1.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password must be at least 12 characters with uppercase, lowercase, numbers, and symbols.'),
                    ),
                  );
                  return;
                }

                if (passwordController1.text != passwordController2.text) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Passwords do not match.'),
                    ),
                  );
                  return;
                }

                try {
                  String userName = nameController.text;
                  String userEmail = emailController.text;

                  // Check if the username exists
                  QuerySnapshot nameQuery = await FirebaseFirestore.instance
                      .collection('users')
                      .where('name', isEqualTo: userName)
                      .get();

                  if (nameQuery.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name already exists. Please choose another.'),
                      ),
                    );
                    return;
                  }

                  // Check if the email exists
                  QuerySnapshot emailQuery = await FirebaseFirestore.instance
                      .collection('users')
                      .where('user', isEqualTo: userEmail)
                      .get();

                  if (emailQuery.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email already exists. Please choose another email.'),
                      ),
                    );
                    return;
                  }

                  // If no duplicate username or email
                  authController.signUp(userEmail, passwordController1.text).then((_) {
                    userData.addUserData(
                      userEmail,
                      passwordController1.text,
                      userName,
                      languageController.text,
                      FirebaseAuth.instance.currentUser!.uid.toString(),
                    );

                    emailController.clear();
                    passwordController1.clear();
                    passwordController2.clear();
                    nameController.clear();
                    languageController.clear();

                    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Error during sign-up. Please try again.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 255, 254, 254),
              ),
              child: const Text("Sign Up", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
