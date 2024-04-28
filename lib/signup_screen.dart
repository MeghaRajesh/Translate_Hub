
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechat/controllers/auth_controller.dart';
import 'package:mechat/controllers/add_user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mechat/widgets/textfield.dart';


class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

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
    super.dispose();
    emailController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
    nameController.dispose();
    languageController.dispose();
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
              style: TextStyle(fontSize: 25, color: const Color.fromARGB(255, 252, 251, 251)),
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
            Center(
              child: ElevatedButton(
                onPressed: () async{
                  if (passwordController1.text != passwordController2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Passwords do not match'),
                    ));
                    return;
                  }
                  if (passwordController1.text.length < 6 ||
                      passwordController2.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Password should be at least 6 characters'),
                    ));
                    return;
                  }
                  // Check if the user name already exists
                  String userName = nameController.text;
                  QuerySnapshot query = await FirebaseFirestore.instance
                      .collection('users')
                      .where('name', isEqualTo: userName)
                      .get();

                  if (query.docs.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Name already exists. Please choose another.'),
                      ),
                    );
                    return;
                  }
                  try{
                    authController
                        .signUp(emailController.text, passwordController1.text)
                        .then((_) {
                      userData.addUserData(
                        emailController.text,
                        passwordController1.text,
                        nameController.text,
                        languageController.text,
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                      );
                      emailController.clear();
                      passwordController1.clear();
                      passwordController2.clear();
                      nameController.clear();
                      languageController.clear();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home',
                        (route) => false,
                      );
                    });
                  } catch (e) {
                    // Error handling during sign-up
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error during sign-up. Please try again.'),
                      ),
                    );
                  }
                  
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 254, 254),  // Black background
                ),
                child: const Text("Sign Up", style:TextStyle(color: Colors.black,)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
