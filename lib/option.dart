import 'package:flutter/material.dart';
import 'voice.dart';

class TranslatePage extends StatelessWidget {
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
              Image.asset(
                'images/option.jpg', // Provide your image path here
                width: 300,
                height: 300,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Handle chat option
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 100), // Adjust the padding as needed
                ),
                child: Text(
                  'Chat',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18), // Adjust the font size as needed
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VoiceTranslation()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      vertical: 30,
                      horizontal: 50), // Adjust the padding as needed
                ),
                child: Text(
                  'Voice Translation',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 18), // Adjust the font size as needed
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}