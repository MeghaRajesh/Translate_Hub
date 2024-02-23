import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(ChatPage());
}

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TranslateHub Chat',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultLanguagePrompt(),
    );
  }
}

class DefaultLanguagePrompt extends StatefulWidget {
  @override
  _DefaultLanguagePromptState createState() => _DefaultLanguagePromptState();
}

class _DefaultLanguagePromptState extends State<DefaultLanguagePrompt> {
  String? _selectedLanguage;

  void _showLanguagePrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Default Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'English';
                  });
                  Navigator.pop(context);
                  _showUserList(context);
                },
              ),
              ListTile(
                title: Text('French'),
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'French';
                  });
                  Navigator.pop(context);
                  _showUserList(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUserList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserListScreen(defaultLanguage: _selectedLanguage!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showLanguagePrompt(context);
          },
          child: Text('Select Default Language'),
        ),
      ),
    );
  }
}

class UserListScreen extends StatelessWidget {
  final String defaultLanguage;

  UserListScreen({required this.defaultLanguage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User to Chat'),
      ),
      body: UserListView(defaultLanguage: defaultLanguage),
    );
  }
}

class UserListView extends StatelessWidget {
  final String defaultLanguage;

  UserListView({required this.defaultLanguage});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            return ListTile(
              title: Text(document['name']),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      defaultLanguage: defaultLanguage,
                      recipient: document['name'],
                    ),
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}

class ChatScreen extends StatelessWidget {
  final String defaultLanguage;
  final String recipient;

  ChatScreen({required this.defaultLanguage, required this.recipient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $recipient'),
      ),
      body: ChatRoom(defaultLanguage: defaultLanguage, recipient: recipient),
    );
  }
}

class ChatRoom extends StatefulWidget {
  final String defaultLanguage;
  final String recipient;

  ChatRoom({required this.defaultLanguage, required this.recipient});

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _controller = TextEditingController();
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');
  String? _currentUser;
  String? _defaultLanguage;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _defaultLanguage = widget.defaultLanguage;
  }

  
 void _getCurrentUser() async {
  try {
    QuerySnapshot userQuery = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: 'email').limit(1).get();
    if (userQuery.docs.isNotEmpty) {
      DocumentSnapshot userSnapshot = userQuery.docs.first;
      // Get the name from the user document
      setState(() {
        _currentUser = userSnapshot['name'];
      });
    } else {
      print('No user found for the provided email.');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }



  }

  void _sendMessage(String message) async {
    if (widget.recipient != null && _defaultLanguage != null) {
      // Determine the target language based on the default language
      String targetLanguage =
          _defaultLanguage == 'English' ? 'fr' : 'en';

      // Translate the message to the target language
      String translatedMessage = await translate(message, targetLanguage);

      // Save the translated message to Firestore
      await _messagesCollection.add({
        'message': translatedMessage,
        'sender': _currentUser,
        'recipient': widget.recipient,
      });
    } else {
      print('User not logged in or default language not set');
    }
  }

  @override
 @override
Widget build(BuildContext context) {
  return Column(
    children: [
      Expanded(
        child: StreamBuilder(
          stream: _messagesCollection
              .where('recipient', isEqualTo: widget.recipient)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

 return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    var message = snapshot.data!.docs[index];
    var sender = message['sender'] ?? 'Unknown Sender';
    var messageText = message['message'] ?? 'No Message';

    return ChatMessage(
      message: messageText,
      sender: sender,
    );
  },
);



          },
        ),
      ),
      Divider(height: 1.0),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
        ),
        child: _buildTextComposer(),
      ),
    ],
  );
}


  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _controller,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    _sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final String sender;

  ChatMessage({required this.message, required this.sender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              child: Text(sender[0]), // Displaying first letter of sender's name
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  sender,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(message),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Dummy translate function, replace with your actual translation logic
Future<String> translate(String text, String targetLanguage) async {
  // Simulate translation delay
  await Future.delayed(Duration(seconds: 1));
  // Dummy translation logic, just return the same text
  return text;
}