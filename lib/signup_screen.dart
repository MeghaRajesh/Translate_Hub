import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechat/controllers/auth_controller.dart';
import 'package:mechat/controllers/add_user_data.dart';
import 'package:mechat/widgets/mybtn.dart';
import 'package:mechat/widgets/textfield.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController1 = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController1.dispose();
    passwordController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.find();
    AddUserData userData = Get.find();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 183, 165, 245),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 200),
            Text('Create Account',
                style: TextStyle(fontSize: 25, color: Colors.grey.shade700)),
            const SizedBox(height: 20),
            MyTextField(
                obscureText: false,
                controller: emailController,
                hint: 'Email',
                color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 15),
            MyTextField(
                obscureText: true,
                controller: passwordController1,
                hint: 'Password',
                color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 15),
            MyTextField(
                obscureText: true,
                controller: passwordController2,
                hint: 'Confirm Password',
                color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 30),
            Btn(
                btntext: 'Sign Up',
                onpressed: () {
                  if (passwordController1.text != passwordController2.text) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Passwords doesnt match')));
                  }
                  if (passwordController1.text.length < 6 ||
                      passwordController2.text.length < 6) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Password should be atleast 6')));
                  }

                  if (passwordController1.text == passwordController2.text) {
                   
                       
                    authController
                        .signUp(emailController.text, passwordController1.text)
                        .then((_) {
                      userData.addUserData(emailController.text,
                          passwordController1.text, FirebaseAuth.instance.currentUser!.uid.toString());
                      emailController.clear();
                      passwordController1.clear();
                      passwordController2.clear();
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/home', (route) => false);
                    });
                  }
                }),
          ]),
        ));
  }
}
