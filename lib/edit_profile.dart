import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  User? _currentUser;
  String _email = "";
  String _name = "";
  String? _selectedLanguage;
  bool _isLoading = true;

  final List<String> languages = [
    'English',
    'French',
    'Spanish',
    'German',
    'Italian',
    'Portuguese',
    'Chinese',
    'Japanese',
    'Korean',
    'Russian',
    'Arabic',
    'Hindi',
    'Turkish',
    'Malayalam'
  ];

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    _email = _currentUser?.email ?? "";
    if (_currentUser != null) {
      _fetchUserData();
    }
  }

  Future<void> _fetchUserData() async {
    if (_currentUser == null) return;

    try {
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('user', isEqualTo: _email)  // Search by email
          .limit(1)  // Get only the first matching document
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = userQuery.docs.first;
        setState(() {
          _name = userSnapshot.get("name") ?? "";
          _selectedLanguage = userSnapshot.get("language") ?? "English";

          _nameController.text = _name;

          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching user data: $error");
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  Future<void> _saveChanges(BuildContext context) async {
    if (_currentUser == null) return;

    try {
      final userCollection = FirebaseFirestore.instance.collection('users');

      QuerySnapshot userQuery = await userCollection
          .where('user', isEqualTo: _email)  // Find the document with the current email
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = userQuery.docs.first;

        Map<String, dynamic> updatedData = {};  // Map to hold updates
        
        if (_nameController.text != _name) {  // Detect name change
          updatedData['name'] = _nameController.text;
        }

        if (_selectedLanguage != null && _selectedLanguage != userSnapshot.get("language")) {  // Detect language change
          updatedData['language'] = _selectedLanguage!;
        }

        if (updatedData.isNotEmpty) {  // If there's anything to update
          await userSnapshot.reference.update(updatedData);  // Update Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Profile updated successfully."),
              duration: Duration(seconds: 2),
            ),
          );
          print("Profile updated successfully.");
        }
      } else {
        print("No document found with the given email.");
      }
    } catch (error) {
      print("Error updating user data: $error");  // Error handling
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImageFromGallery,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/profilepic.jpg'),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors .black,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              color: Colors .white,
                              onPressed: _pickImageFromGallery,
                            ),
                          ),
                       ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Name Field
              TextFormField(
                 controller: _nameController,
                 decoration: InputDecoration(
                   border: InputBorder.none,
                   prefixIcon: Icon(Icons.account_circle, color: Colors.black),
                   prefixIconConstraints: BoxConstraints(
                     minWidth: 50, // Increase space between icon and text
                   ),
                   contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                 ),
                 cursorColor: Colors .black,
                 onChanged: (value) {
                   _name = value;
                 },
               ),
               const SizedBox(height: 10),
               // Email Field with Mail Icon
               Text(
                 'Email',
                 style: const TextStyle(
                   fontWeight: FontWeight. bold,
                   color: Colors. black,
                 ),
               ),
               TextFormField(
                 initialValue: _email,
                 readOnly: true,
                 decoration: InputDecoration(
                   border: InputBorder.none,
                   prefixIcon: Icon(Icons.email, color: Colors.black),
                   prefixIconConstraints: BoxConstraints(
                     minWidth: 50, // Increase space between icon and text
                   ),
                   contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                 ),
                 cursorColor: Colors .black,
               ),
              const SizedBox(height: 10),
              // Language Dropdown
              Text(
                'Language',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.language, color: Colors.black),
                ),
                items: languages.map((String language) {
                  return DropdownMenuItem(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
                onChanged: (String? newLanguage) {
                  setState(() {
                    _selectedLanguage = newLanguage;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _saveChanges(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_picker/image_picker.dart';

// class EditProfilePage extends StatefulWidget {
//   @override
//   _EditProfilePageState createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _languageController = TextEditingController();

//   User? _currentUser;
//   String _email = "";
//   String _name = "";
//   String _language = "";
//   bool _isLoading = true;

//   final ImagePicker _picker = ImagePicker();
//   XFile? _imageFile;

//   @override
//   void initState() {
//     super.initState();
//     _currentUser = FirebaseAuth.instance.currentUser;
//     _email = _currentUser?.email ?? "";
//     if (_currentUser != null) {
//       _fetchUserData();
//     }
//   }

//   Future<void> _fetchUserData() async {
//     if (_currentUser == null) return;

//     try {
//       QuerySnapshot userQuery = await FirebaseFirestore.instance
//           .collection('users')
//           .where('user', isEqualTo: _email)  // Search by email
//           .limit(1)  // Get only the first matching document
//           .get();

//       if (userQuery.docs.isNotEmpty) {
//         DocumentSnapshot userSnapshot = userQuery.docs.first;
//         setState(() {
//           _name = userSnapshot.get("name") ?? "";
//           _language = userSnapshot.get("language") ?? "English";

//           _nameController.text = _name;
//           _languageController.text = _language;

//           _isLoading = false;
//         });
//         print("Fetched language: $_language");
//       }
//     } catch (error) {
//       setState(() {
//         _isLoading = false;
//       });
//       print("Error fetching user data: $error");
//     }
//   }

//   Future<void> _pickImageFromGallery() async {
//     final XFile? pickedImage = await _picker.pickImage(
//       source: ImageSource.gallery,
//     );

//     if (pickedImage != null) {
//       setState(() {
//         _imageFile = pickedImage;
//       });
//     }
//   }

//   Future<void> _saveChanges(BuildContext context) async {
//     if (_currentUser == null) return;

//     try {
//       final userCollection = FirebaseFirestore.instance.collection('users');

//       QuerySnapshot userQuery = await userCollection
//           .where('user', isEqualTo: _email)  // Find the document with the current email
//           .limit(1)
//           .get();

//       if (userQuery.docs.isNotEmpty) {
//         DocumentSnapshot userSnapshot = userQuery.docs.first;

//         String currentName = _nameController.text;
//         String currentLanguage = _languageController.text;
        
      

//         Map<String, dynamic> updatedData = {};  // Map to hold updates
        
//         if (_nameController.text == _name) {  // Detect name change
//         updatedData['name'] = _nameController.text;
//         }

//         if (currentLanguage == _language) {  // Detect language change
//           updatedData['language'] = currentLanguage;
//         }

//         if (updatedData.isNotEmpty) {  // If there's anything to update
//           await userSnapshot.reference.update(updatedData);// Update Firestore
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("Profile updated successfully."),
//               duration: Duration(seconds: 2),  // Adjust duration as needed
//             ),
//           );
//           print("Profile updated successfully.");
//         }
//       } else {
//         print("No document found with the given email.");
//       }
//     } catch (error) {
//       print("Error updating user data: $error");  // Error handling
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors. black,
//         title: const Text('Edit Profile', style: TextStyle(color: Colors. white)),
//       ),
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors .white, Colors. white],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets. all (16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment .start,
//             children: [
//               const SizedBox(height: 20),
//               Center(
//                 child: GestureDetector(
//                   onTap: _pickImageFromGallery,
//                   child: Stack(
//                     children: [
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundImage: AssetImage('images/profilepic.jpg'),
//                       ),
//                       Positioned(
//                         bottom: 0,
//                         right: 0,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors .black,
//                           ),
//                           child: IconButton(
//                             icon: const Icon(Icons.camera_alt),
//                             color: Colors .white,
//                             onPressed: _pickImageFromGallery,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Name Field with Profile Icon
//               Text(
//                 'Name',
//                 style: const TextStyle(
//                   fontWeight: FontWeight. bold,
//                   color: Colors. black,
//                 ),
//               ),
//               TextFormField(
//                 controller: _nameController,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.account_circle, color: Colors.black),
//                   prefixIconConstraints: BoxConstraints(
//                     minWidth: 50, // Increase space between icon and text
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 ),
//                 cursorColor: Colors .black,
//                 onChanged: (value) {
//                   _name = value;
//                 },
//               ),
//               const SizedBox(height: 10),
//               // Email Field with Mail Icon
//               Text(
//                 'Email',
//                 style: const TextStyle(
//                   fontWeight: FontWeight. bold,
//                   color: Colors. black,
//                 ),
//               ),
//               TextFormField(
//                 initialValue: _email,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.email, color: Colors.black),
//                   prefixIconConstraints: BoxConstraints(
//                     minWidth: 50, // Increase space between icon and text
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 ),
//                 cursorColor: Colors .black,
//               ),
//               const SizedBox(height: 10),
//               // Language Field with Language Icon
//               Text(
//                 'Language',
//                 style: const TextStyle(
//                   fontWeight: FontWeight .bold,
//                   color: Colors. black,
//                 ),
//               ),
//               TextFormField(
//                 controller: _languageController,
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   prefixIcon: Icon(Icons.language, color: Colors.black),
//                   prefixIconConstraints: BoxConstraints(
//                     minWidth: 50, // Increase space between icon and text
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
//                 ),
//                 cursorColor: Colors .black,
//                 onChanged: (value) {
//                   _language = value;
//                 },
//               ),
//               const SizedBox(height: 20),
//               Center(
//                 child: ElevatedButton(
//                   onPressed: () { _saveChanges(context);},
//                   style: ButtonStyle(
//                     backgroundColor: MaterialStateProperty.all(Colors. black), 
//                   ),
//                   child: Text("Save Changes"), 
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(
//     home: EditProfilePage(),
//   ));
// }
