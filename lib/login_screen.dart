// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mechat/controllers/auth_controller.dart';
// import 'package:mechat/screens/signup_screen.dart';
// import 'package:mechat/widgets/mybtn.dart';
// import 'package:mechat/widgets/textfield.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   AuthController authController = Get.find();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 183, 165, 245),
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 150),
//               const Text('TranslateHub',
//                   style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 70),
//               MyTextField(
//                 hint: 'Email',
//                 obscureText: false,
//                 color: Colors.white.withOpacity(0.5),
//                 controller: emailController,
//               ),
//               const SizedBox(
//                 height: 15,
//               ),
//               MyTextField(
//                 hint: 'Password',
//                 obscureText: true,
//                 color: Colors.white.withOpacity(0.5),
//                 controller: passwordController,
//               ),
//               const SizedBox(height: 25),
//               Btn(
//                   btntext: 'Sign in',
//                   onpressed: () async {
//                     FocusScope.of(context).unfocus();

//                     try {
//                       if (passwordController.text.isEmpty ||
//                           emailController.text.isEmpty) {
//                         Get.snackbar(
//                           'Error',
//                           'Field is empty',
//                           snackPosition: SnackPosition.BOTTOM,
//                         );
//                       } else {
//                         authController
//                             .signIn(emailController.text,
//                                 passwordController.text, context)
//                             .then((value) {
//                           emailController.clear();
//                           passwordController.clear();
//                         });
//                       }
//                     } catch (e) {
//                       Get.snackbar(
//                         'Error',
//                         'please try again later',
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                     }
//                   }),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 70),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     const Text('Not a member?', style: TextStyle(fontSize: 16)),
//                     GestureDetector(
//                         onTap: () {
//                           FocusScope.of(context).unfocus();
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => const SignUpPage()));
//                         },
//                         child: const Text('Register now',
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold))),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ));
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mechat/controllers/auth_controller.dart';
import 'package:mechat/screens/signup_screen.dart';
import 'package:mechat/screens/option.dart'; // Import OptionPage
import 'package:mechat/widgets/mybtn.dart';
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
      backgroundColor: const Color.fromARGB(255, 183, 165, 245),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 150),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TranslateHub',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20), // Adjust spacing as needed
                Center(
                  child: Image.asset(
                    'images/signin.jpg',
                    width: 100, // Adjust width as needed
                    height: 100, // Adjust height as needed
                  ),
                ),
              ],
            ),
            const SizedBox(height: 70),
            MyTextField(
              hint: 'Email',
              obscureText: false,
              color: Colors.white.withOpacity(0.5),
              controller: emailController,
            ),
            const SizedBox(height: 15),
            MyTextField(
              hint: 'Password',
              obscureText: true,
              color: Colors.white.withOpacity(0.5),
              controller: passwordController,
            ),
            const SizedBox(height: 25),
            Btn(
              btntext: 'Sign in',
              onpressed: () async {
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
                      // Navigate to OptionPage after successful sign in
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
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('Not a member?', style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
