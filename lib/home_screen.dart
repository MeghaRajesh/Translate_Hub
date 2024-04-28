import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mechat/screens/chat_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CollectionReference collectionRef =
      FirebaseFirestore.instance.collection('users');
  String? sName; // Changed variable name to reflect name instead of email
  String? currentUserid;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserid = currentUser.uid.toString();
      print('Here is the uid: $currentUserid');
    }

    getCurrentUserName(); // Changed function name
  }

  void getCurrentUserName() async { // Changed function name
    try {
      DocumentSnapshot documentSnapshot =
          await collectionRef.doc(currentUserid).get();
      if (documentSnapshot.exists) {
        setState(() {
          sName = documentSnapshot['name'] as String?; // Fetching name instead of email
        });
      }
    } catch (e) {
      print('Error getting current user name: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 252, 253),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 6, 5, 8),
        title: const Text(
          'Chats',
          style: TextStyle(letterSpacing: 5, color: Colors.white),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       FirebaseAuth.instance.signOut().then((value) =>
        //           Navigator.of(context)
        //               .pushNamedAndRemoveUntil('/signout', (route) => false));
        //     },
        //     icon: Icon(Icons.logout, color: Colors.white),
        //   ),
        // ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              return currentUserid != documentSnapshot['useruid']
                  ? GestureDetector(
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 5,
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 8, 7, 7),
                            child: Text(
                              documentSnapshot['name'][0]
                              .toString()
                              .toUpperCase(), // Display first letter of the name
                              style: TextStyle(
                                color: Colors.white, // Set text color to white
                              ),
                            ),
                          ),
                        ),

                        title: Text(
                          documentSnapshot['name'], // Display name instead of email
                          style: const TextStyle(
                            letterSpacing: 3,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => 
                              ChatScreen(
                                  usermail: documentSnapshot['name'].toString(), // Pass name instead of email
                                  mail: sName.toString(), // Pass current user's name
                                  ),
                              ),
                        );
                      },
                    )
                  : SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
