import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechat/controllers/auth_controller.dart';
import 'package:mechat/screens/option.dart';
import 'package:mechat/screens/signup_screen.dart';
import 'package:mechat/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color changed to black
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TranslateHub',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Text color changed to white
                  ),
                ),
                const SizedBox(height: 20),
                
                
                  ClipOval( // This creates the circular shape
              child: Image.asset(
                'images/signin.jpg', // Make sure this image exists in your assets folder
                width: 150, // Adjust the size as needed
                height: 150,
                fit: BoxFit.cover, // Ensures the image covers the oval shape
              ),
            ),
                
              ],
            ),
            const SizedBox(height: 70),
            MyTextField(
              hint: 'Email',
              obscureText: false,
              color: Colors.white, // Text field color changed to white
              controller: emailController,
            ),
            const SizedBox(height: 15),
            MyTextField(
              hint: 'Password',
              obscureText: true,
              color: Colors.white, // Text field color changed to white
              controller: passwordController,
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(255, 249, 250, 249), // Button color changed to light green
                onPrimary: Colors.black, // Text color on button set to black
                elevation: 10, // Elevation for 3D effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Rounded corners for 3D effect
                ),
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Padding for a substantial button
              ),
              onPressed: () async {
                FocusScope.of(context).unfocus();
                try {
                  if (passwordController.text.isEmpty || emailController.text.isEmpty) {
                    Get.snackbar(
                      'Error',
                      'Field is empty',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    authController.signIn(emailController.text, passwordController.text, context).then((value) {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TranslatePage()));
                      emailController.clear();
                      passwordController.clear();
                    });
                  }
                } catch (e) {
                  Get.snackbar(
                    'Error',
                    'please try again later',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              child: Text("Sign In"), // Text on the button
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

