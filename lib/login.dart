import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'option.dart';


class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signIn(BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the Home page after successful sign-in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TranslatePage()),
      );
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
      // Show error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in. Please check your credentials."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 83, 34, 223), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'TranslateHub',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Translate to Go',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Image.asset(
                'images/signin.jpg', // Provide your image path here
                width: 300,
                height: 300,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _signIn(
                            context); // Call the _signIn method which navigates to TranslatePage on successful sign-in
                      },
                      child: Text('Sign In'),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(
                              color: Color.fromARGB(255, 77, 73, 124)),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpPage()),
                            );
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Color.fromARGB(255, 77, 73, 124),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
