import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mechat/screens/home_screen.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({Key? key}) : super(key: key);

  @override
  _LanguageSelectionPageState createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late String? defaultLanguage;
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      getCurrentUserDefaultLanguage(currentUser.uid);
    }
  }

  void getCurrentUserDefaultLanguage(String userId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await collectionRef.doc(userId).get();
      if (documentSnapshot.exists) {
        setState(() {
          defaultLanguage = documentSnapshot['default_language'] as String?;
        });
      }
    } catch (e) {
      print('Error getting default language: $e');
    }
  }

  Future<void> selectDefaultLanguage(String language) async {
    try {
      await collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).update({
        'default_language': language,
      });
      setState(() {
        defaultLanguage = language;
      });

      // Navigate to HomeScreen after setting default language
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print('Error setting default language: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 165, 245),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Select Default Language',
          style: TextStyle(letterSpacing: 5, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                selectDefaultLanguage('English');
              },
              style: ElevatedButton.styleFrom(
                //primary: Colors.green, // Change the background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Make the border oval-shaped
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5), // Increase the padding
              ),
              child: Text(
                'English',
                style: TextStyle(color: Colors.white, letterSpacing: 5), // Increase letter spacing
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                selectDefaultLanguage('French');
              },
              style: ElevatedButton.styleFrom(
                //primary: Colors.orange, // Change the background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // Make the border oval-shaped
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100), // Increase the padding
              ),
              child: Text(
                'French',
                style: TextStyle(color: Colors.white, letterSpacing: 5), // Increase letter spacing
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
