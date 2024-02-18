import 'package:flutter/material.dart';
import 'login.dart';


import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyB_789YKZjEaV5kC9kxDA2V37kPzVnFmfk',
     appId: '1:73015744297:android:fc653c848fe153fed2c938', 
     messagingSenderId: '73015744297', 
     projectId: 'finalproject-edf90'
    )
    
  
  );
  runApp(
    MaterialApp(
      title: 'Translate App',
      home: Directionality(
        textDirection: TextDirection.ltr, // Change this according to your app's text direction
        child: SignInPage(),
      ),
    ),
  );
}