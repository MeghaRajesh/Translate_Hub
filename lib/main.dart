
import 'package:flutter/material.dart';

import 'whts.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyAm9cQ6GwWOH0D-meVADOGyHPExOevGkqo',
     appId: '1:862178512798:android:27cb3e0a85f9424ee5108f', 
     messagingSenderId: '862178512798', 
     projectId: 'transhub-2eaf3'
    )
    
  
  );
  
  runApp(Whats());
}








