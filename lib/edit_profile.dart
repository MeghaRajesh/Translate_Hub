import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _name = "John Doe";
  String _address = "123 Main Street";
  String _email = "johndoe@example.com";
  String _phoneNumber = "+1234567890";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color.fromARGB(255, 83, 34, 223), Colors.white],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: () {
                    print('Change profile photo');
                  },
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('images/profilepic.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            print('Change profile photo');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 25),
                        SizedBox(width: 20), // Add space before the "Name" label
                        Text(
                          'Name',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 0), // Add space between the "Name" label and the text
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _name = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 10), // Add space after the text box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 25),
                        SizedBox(width: 20), // Add space before the "Address" label
                        Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 10), // Add space between the "Address" label and the text
                    TextFormField(
                      initialValue: _address,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _address = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 10), // Add space after the text box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 25),
                        SizedBox(width: 20), // Add space before the "Email" label
                        Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 10), // Add space between the "Email" label and the text
                    TextFormField(
                      initialValue: _email,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //SizedBox(height: 10), // Add space after the text box
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(height: 25),
                        SizedBox(width: 20), // Add space before the "Phone Number" label
                        Text(
                          'Phone Number',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    //SizedBox(height: 10), // Add space between the "Phone Number" label and the text
                    TextFormField(
                      initialValue: _phoneNumber,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    print('Updated Profile:');
                    print('Name: $_name');
                    print('Address: $_address');
                    print('Email: $_email');
                    print('Phone Number: $_phoneNumber');
                  },
                  child: Text('Save Changes'),
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
    home: EditProfilePage(),
  ));
}
