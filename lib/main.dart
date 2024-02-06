import 'package:flutter/material.dart';
import 'whts.dart';

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
  
  runApp(Whats());
}
