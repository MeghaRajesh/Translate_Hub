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
  String? smail;

  String? currentUserid;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserid = currentUser.uid.toString();
      print('Here is the uid: $currentUserid');
    }

    getCurrentUserEmail();
  }

  void getCurrentUserEmail() async {
    try {
      DocumentSnapshot documentSnapshot =
          await collectionRef.doc(currentUserid).get();
      if (documentSnapshot.exists) {
        setState(() {
          smail = documentSnapshot['user'] as String?;
        });
      }
    } catch (e) {
      print('Error getting current user email: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 183, 165, 245),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Me Chat',
          style: TextStyle(letterSpacing: 5, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/signout', (route) => false));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionRef.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.hasData ? snapshot.data!.docs.length : 0,
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
                            backgroundColor: Colors.deepPurple,
                            child: Text(
                              documentSnapshot['user'][0]
                                  .toString()
                                  .toUpperCase(),
                            ),
                          ),
                        ),
                        title: Text(
                          documentSnapshot['user'],
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
                              usermail: documentSnapshot['user'].toString(),
                              mail: smail.toString(),
                            ),
                          ),
                        );
                      },
                    )
                  : (snapshot.data!.docs.length == 1)
                      ? const Center(
                          child: Text('No new user'),
                        )
                      : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
