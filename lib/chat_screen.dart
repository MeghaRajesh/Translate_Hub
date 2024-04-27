import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mechat/controllers/access_controller.dart';
import 'package:mechat/controllers/message_controller.dart';
import 'package:mechat/widgets/chat_bubble.dart';
import 'package:mechat/widgets/chat_image_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String usermail;
  final String mail;
  const ChatScreen({required this.usermail, Key? key, required this.mail})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatcontroller = TextEditingController();
  final TextEditingController _controller = TextEditingController();

  ChatRoomController chatRoom = Get.find();
  String? currentUserid;
  String defaultLanguage = ''; // Default language
  late String chatdoc; // Declare chatdoc as class-level variable

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      currentUserid = currentUser.uid.toString();
      print('Here is the uid: $currentUserid');

      // Fetch user's language preference from Firestore and set as default language
      fetchUserLanguage(currentUserid!).then((language) {
        setState(() {
          defaultLanguage = LanguageConverter.convertToShortForm(language);
        });
      });
    }

    // Initialize chatdoc in initState
    List ids = [widget.usermail, widget.mail];
    ids.sort();
    chatdoc = ids.join("_");
  }

  void sendMessage(String message) async {
    try {
      // Construct a new message document
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatdoc)
          .collection('messages')
          .add({
        'message': message,
        'useruid': currentUserid,
        // Add other message properties as needed
        'timestamp': Timestamp.now(),
      });
      
      // Clear the text input field after sending the message
      chatcontroller.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Handle error accordingly
    }
  }

  Future<String> fetchUserLanguage(String userId) async {
  try {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>?
      return data?['language'] as String? ?? 'english'; // Access 'language' field safely
    } else {
      // User document not found, handle accordingly
      return 'english'; // Default language if user document not found
    }
  } catch (e) {
    print('Error fetching user language: $e');
    return 'english'; // Default language in case of error
  }
}


  // Translate message to default language
  Future<String> translateMessage(String message, String targetLanguage) async {
    String translatedMessage = message;
    try {
      translatedMessage = await GoogleTranslator.translate(message, targetLanguage);
    } catch (e) {
      print('Error translating message: $e');
    }
    return translatedMessage;
  }

  @override
  Widget build(BuildContext context) {
    List ids = [widget.usermail, widget.mail];
    ids.sort();
    chatdoc = ids.join("_");

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 251, 253),
      appBar: AppBar(
        title: Text(
          '${widget.usermail}', // Display the name of the person you're chatting with
          style: TextStyle(
            color: Colors.white, // Text color for visibility
          ),
        ),
        backgroundColor: Colors.black, // Make the entire AppBar black
      ),


      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc(chatdoc)
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CupertinoActivityIndicator());
  } else {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];
              final Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
              final isCurrentUser = (data['useruid'] as String) == currentUserid;
              final String message = data['message'] as String;
              final String imageUrl = data['imageurl'] as String? ?? ''; // Ensure imageUrl is not null
              final String caption = data['caption'] as String? ?? ''; // Ensure caption is not null
              

              
              return FutureBuilder<String>(
                        future: translateMessage(message, defaultLanguage), // Translation logic
                        builder: (context, futureSnapshot) {
                          if (futureSnapshot.connectionState == ConnectionState.waiting) {
                            return SizedBox(); // Wait until the translation is ready
                          } else {
                            return Align(
                              alignment: isCurrentUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  color: isCurrentUser
                                      ? Colors.grey[700] // Darker shade for outgoing messages
                                      : Colors.grey[300], // Lighter shade for incoming messages
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      futureSnapshot.data!, // Translated message
                                      style: TextStyle(
                                        color: isCurrentUser
                                            ? Colors.white // Text color for outgoing messages
                                            : Colors.black, // Text color for incoming messages
                                      ),
                                    ),
                                    if (imageUrl.isNotEmpty) // Only add if imageUrl exists
                                      ChatImageBubble(
                                        chatImage: imageUrl,
                                        caption: caption, // Ensure a caption is given
                                        isCurrentUser: isCurrentUser,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
              
            },
          ),
        ),
        // Text input field and send button
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: chatcontroller,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 253, 251, 251), // Grey color for hint text
                    ),
                    fillColor: Color.fromARGB(255, 7, 7, 7), // Background color for the text field
                    filled: true, // Ensures the background color is applied
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0), // Create an oval shape
                        borderSide: BorderSide(
                          color: Colors.grey, // Border color
                        ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.white, // White color for the text
                  ),
                ),
              ),

              SizedBox(width: 8.0),
              IconButton(
                onPressed: () {
                  sendMessage(chatcontroller.text);
                },
                icon: Icon(
                    Icons.send,
                    color: const Color.fromARGB(255, 7, 7, 7), // Send icon color
                  ),
                  color: Colors.black,
              ),

            ],
          ),
        ),
      ],
    );
  }
},

      ),
    );
  }
}

class GoogleTranslator {
  static const _apiKey = 'AIzaSyCr83LIwD9TuHNI11hlGVq7gBz5oTLhOSg'; // Replace with your actual API key

  static Future<String> translate(String text, String targetLanguage) async {
    final endpoint = Uri.parse(
        'https://translation.googleapis.com/language/translate/v2?key=$_apiKey');
    try {
      final response = await http.post(
        endpoint,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'target': targetLanguage,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final translatedText = data['data']['translations'][0]['translatedText'];
        return translatedText;
      } else {
        throw Exception('Failed to translate text: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error translating text: $e');
      rethrow;
    }
  }
}

class LanguageConverter {
  static const Map<String, String> languageMap = {
    'english': 'en',
    'french': 'fr',
    'spanish': 'es',
    'german': 'de',
    'italian': 'it',
    'portuguese': 'pt',
    'chinese': 'zh',
    'japanese': 'ja',
    'korean': 'ko',
    'russian': 'ru',
    'arabic': 'ar',
    'hindi': 'hi',
    'turkish': 'tr',
    // Add more languages as needed
  };

  static String convertToShortForm(String languageName) {
    return languageMap[languageName.toLowerCase()] ?? 'en'; // Default to English if not found
  }
}



