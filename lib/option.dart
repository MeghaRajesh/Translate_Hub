import 'package:flutter/material.dart';
import 'package:mechat/screens/chat_screen.dart';
import 'package:mechat/screens/home_screen.dart';
import 'package:mechat/screens/language_selection_page.dart';
import 'package:mechat/screens/login_screen.dart';
import 'voice.dart';
import 'edit_profile.dart'; // Import the edit profile page
import 'login_screen.dart'; // Import the login page
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class TranslatePage extends StatefulWidget {
  late final String? smail;

  TranslatePage({Key? key, this.smail}) : super(key: key);

  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  late String? currentUserid;
  late DocumentSnapshot documentSnapshot; // Define documentSnapshot here

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserid = currentUser.uid.toString();
      print('Here is the uid: $currentUserid');
    }

    getCurrentUserEmail();
  }

  void getCurrentUserEmail() async {
    try {
      documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserid)
          .get();
      if (documentSnapshot.exists) {
        setState(() {
          widget.smail = documentSnapshot['user'] as String?;
        });
      }
    } catch (e) {
      print('Error getting current user email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 34, 223),
        title: Text(
          'TranslateHub',
          style: TextStyle(color: Colors.white),
        ),
        leading: PopupMenuButton(
          icon: Icon(Icons.menu, color: Colors.white),
          itemBuilder: (BuildContext context) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.account_circle), // Add profile icon
                title: Text('Profile'),
              ),
              value: 'profile',
            ),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.logout), // Add logout icon
                title: Text('Logout'),
              ),
              value: 'logout',
            ),
          ],
          onSelected: (String value) {
            if (value == 'profile') {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              );
            } else if (value == 'logout') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            }
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color.fromARGB(255, 83, 34, 223),
              Color.fromARGB(255, 204, 187, 250)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              Image.asset(
                'images/option.jpg', // Provide your image path here
                width: 300,
                height: 300,
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LanguageSelectionPage(
                        // usermail: documentSnapshot['user'].toString(),
                        // mail: widget.smail.toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Make the border oval-shaped
                  ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Make the border oval-shaped
                  ),
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
