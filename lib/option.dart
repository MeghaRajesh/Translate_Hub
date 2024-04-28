import 'package:flutter/material.dart';
import 'package:mechat/screens/chat_screen.dart';
import 'package:mechat/screens/home_screen.dart';
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
        backgroundColor: Color.fromARGB(255, 10, 10, 10),
        title: Text(
          'TranslateHub',
          style: TextStyle(color: const Color.fromARGB(255, 252, 249, 249)),
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
              Color.fromARGB(255, 5, 1, 14),
              Color.fromARGB(255, 3, 2, 8)
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(200), // Increase the radius to create a larger circle
                child: Image.asset(
                  'images/img.png', // Provide your image path here
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover, // Ensure the image covers the circle
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // Make the border oval-shaped
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: 100),
                      backgroundColor: Color.fromARGB(255, 255, 249, 249) // Adjust the padding as needed
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
                      vertical: 20,
                      horizontal: 50),
                      backgroundColor: Color.fromARGB(255, 255, 249, 249) // Adjust the padding as needed
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
