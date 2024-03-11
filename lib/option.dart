import 'package:final_proj/lang.dart';
import 'package:flutter/material.dart';
import 'voice.dart';
import 'edit_profile.dart'; // Import the edit profile page
import 'login.dart'; // Import the login page

class TranslatePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 34, 223),
        title: Text('TranslateHub',
        
        style: TextStyle(color: Colors.white),
        ),
        leading: PopupMenuButton(
          icon: Icon(Icons.menu,color: Colors.white),
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
                MaterialPageRoute(builder: (context) => SignInPage()),
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
            colors: [const Color.fromARGB(255, 83, 34, 223), Color.fromARGB(255, 204, 187, 250)],
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
                    MaterialPageRoute(builder: (context) => LanguagePage()),
                  );
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

