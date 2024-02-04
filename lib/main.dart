// import 'package:flutter/material.dart';
// import 'whts.dart';

// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: const FirebaseOptions(apiKey: 'AIzaSyB_789YKZjEaV5kC9kxDA2V37kPzVnFmfk',
//      appId: '1:73015744297:android:fc653c848fe153fed2c938', 
//      messagingSenderId: '73015744297', 
//      projectId: 'finalproject-edf90'
//     )
    
  
//   );
  
//   runApp(Whats());
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddUserInfo(),
    );
  }
}

class AddUserInfo extends StatefulWidget {
  @override
  _AddUserInfoState createState() => _AddUserInfoState();
}

class _AddUserInfoState extends State<AddUserInfo> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  Future<void> _addUserInfo() async {
    try {
      String name = _nameController.text.trim();
      int age = int.parse(_ageController.text.trim());

      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'age': age,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User info added to Firestore')),
      );

      _nameController.clear();
      _ageController.clear();
    } catch (e) {
      print('Error adding user info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User Info'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 12.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addUserInfo,
              child: Text('Add User Info'),
            ),
          ],
        ),
      ),
    );
  }
}
