import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _languageController = TextEditingController();

  User? _currentUser; // Nullable user
  String _email = ""; // Default empty string for email
  String _name = "";
  String _language = "";
  bool _isLoading = true; // Loading indicator state

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser; // Get current user
    _email = _currentUser?.email ?? ""; // Get email, fallback to empty string
    if (_currentUser != null) {
      _fetchUserData(); // Fetch additional user data
    }
  }

  Future<void> _fetchUserData() async {
    try {
      if (_currentUser == null) return; // Exit if no logged-in user
      
      QuerySnapshot userQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('user', isEqualTo: _email) // Fetch by email
          .limit(1) // First matching document
          .get();

      if (userQuery.docs.isNotEmpty) { // Check if data exists
        DocumentSnapshot userSnapshot = userQuery.docs.first; // Get first doc
        setState(() { // Update state with data
          _name = userSnapshot.get("name") ?? "";
          _language = userSnapshot.get("language") ?? "English";

          _nameController.text = _name; 
          _languageController.text = _language;

          _isLoading = false; // Data loaded, stop loading
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false; // Stop loading on error
      });
      print("Error fetching user data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Loading indicator
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 83, 34, 223), Colors.white], // Gradient
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0), // Padding for content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20), // Spacing
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle changing profile photo
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/profilepic.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit), // Edit icon for photo
                          onPressed: () {
                            // Handle changing profile photo
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20), // Spacing
              // Name Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Border decoration
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20), // Spacing
                        Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _nameController, // Controller for name
                      decoration: InputDecoration(
                        border: InputBorder.none, // No border
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Padding
                      ),
                      cursorColor: Colors.black, // Cursor color
                      onChanged: (value) {
                        _name = value; // Update name
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Spacing
              // Email Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Border decoration
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Cross-axis alignment
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20), // Spacing
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // Text color
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      initialValue: _email, // Set initial email
                      readOnly: true, // Email is read-only
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Padding
                      ),
                      cursorColor: Colors.black, // Cursor color
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Spacing
              // Language Field
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black), // Border decoration
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Cross-axis alignment
                  children: [
                    Row(
                      children: [
                        SizedBox(width: 20), // Spacing
                        Text(
                          'Language',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      controller: _languageController, // Language controller
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20), // Padding
                      ),
                      cursorColor: Colors.black, // Cursor color
                      onChanged: (value) {
                        _language = value; // Update language
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Spacing
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Save changes and display updated profile
                    print("Updated Profile:");
                    print("Name: $_name");
                    print("Email: $_email");
                    print("Language: $_language");
                  },
                  child: Text("Save Changes"), // Button label
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EditProfilePage(), // Load with Edit Profile page
  ));
}

