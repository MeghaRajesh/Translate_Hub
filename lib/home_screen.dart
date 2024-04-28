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
  String? sName;
  String? currentUserid;
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserid = currentUser.uid;
      getCurrentUserName();
    }
  }

  void getCurrentUserName() async {
    try {
      DocumentSnapshot documentSnapshot =
          await collectionRef.doc(currentUserid).get();
      if (documentSnapshot.exists) {
        setState(() {
          sName = documentSnapshot['name'] as String?;
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
          style: TextStyle(
            fontSize: 25,
            letterSpacing: 5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,  // White background
                borderRadius: BorderRadius.circular(25),  // Oval shape
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),  // Soft shadow
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: Offset(0, 2),  // Shadow position
                  ),
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search by name",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),  // Search icon
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),  // Padding for text
                ),
                style: TextStyle(
                  color: Colors.black,  // Text color
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(  // Ensure the ListView takes the remaining space
            child: StreamBuilder<QuerySnapshot>(
              stream: collectionRef.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Filter users based on search query
                List<DocumentSnapshot> filteredDocs = snapshot.data!.docs.where(
                  (doc) {
                    String userName = (doc['name'] as String).toLowerCase();
                    return userName.contains(searchQuery.toLowerCase());  // Check if the name contains the search query
                  },
                ).toList();

                return ListView.builder(
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot = filteredDocs[index];
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
                                      .toUpperCase(),  // First letter of the name
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['name'],  // Display the user's name
                                style: const TextStyle(
                                  letterSpacing: 3,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(
                                    usermail: documentSnapshot['name'].toString(),  // Pass name
                                    mail: sName.toString(),
                                  ),
                                ),
                              );
                            },
                          )
                        : SizedBox.shrink();  // Don't display if it's the current user
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
