// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mechat/controllers/access_controller.dart';
// import 'package:mechat/controllers/message_controller.dart';
// import 'package:mechat/widgets/chat_bubble.dart';
// import 'package:mechat/widgets/chat_image_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final String usermail;
//   final String mail;
//   const ChatScreen({required this.usermail, Key? key, required this.mail})
//       : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController chatcontroller = TextEditingController();
//   final TextEditingController _controller = TextEditingController();

//   ChatRoomController chatRoom = Get.find();
//   String? currentUserid;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final currentUser = FirebaseAuth.instance.currentUser;
//     if (currentUser != null) {
//       currentUserid = currentUser.uid.toString();
//       print('Here is the uid: $currentUserid');
//     }
//   }

//   AccessStorage access = Get.find();

//   @override
//   void dispose() {
//     chatcontroller.dispose();
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     List ids = [widget.usermail, widget.mail];

//     ids.sort();
//     String chatdoc = ids.join("_");

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 183, 165, 245),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chatroom')
//             .doc(chatdoc)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CupertinoActivityIndicator());
//           } else {
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       String currentUser =
//                           FirebaseAuth.instance.currentUser!.uid;
//                       final DocumentSnapshot documentSnapshot =
//                           snapshot.data!.docs[index];

//                       final isCurrentUser =
//                           documentSnapshot['useruid'] == currentUser;

//                       return Column(
//                         children: [
//                           ChatBubble(
//                               chatMsg: documentSnapshot['message'],
//                               isCurrentUser: isCurrentUser),
//                           ChatImageBubble(
//                               chatImage: documentSnapshot['imageurl'],
//                               isCurrentUser: isCurrentUser,
//                               caption: documentSnapshot['caption']),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 7, right: 10, bottom: 10),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           access.getAccess(context);

//                           showModalBottomSheet(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 183, 165, 245),
//                             context: context,
//                             builder: (context) {
//                               return Column(
//                                 children: [
//                                   const SizedBox(height: 50),
//                                   Center(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         access.getAccess(context);
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               content: SizedBox(
//                                                 height: 150,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceAround,
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         access.pickImage(
//                                                             ImageSource.camera);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const ListTile(
//                                                         leading:
//                                                             Icon(Icons.camera),
//                                                         title: Text('Camera'),
//                                                       ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         access.pickImage(
//                                                             ImageSource
//                                                                 .gallery);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const ListTile(
//                                                         leading:
//                                                             Icon(Icons.photo),
//                                                         title: Text('Gallary'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       },
//                                       child: Container(
//                                         height: 100,
//                                         width: 100,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.5),
//                                               spreadRadius: 0.1,
//                                               blurRadius: 7,
//                                             )
//                                           ],
//                                         ),
//                                         child: const Icon(
//                                             Icons.camera_alt_outlined),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 50),
//                                   Container(
//                                     height: 50,
//                                     width: 250,
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromARGB(
//                                           125, 255, 255, 255),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: TextField(
//                                       maxLines: null,
//                                       controller: _controller,
//                                       textCapitalization:
//                                           TextCapitalization.sentences,
//                                       decoration: const InputDecoration(
//                                           hintText: 'Caption',
//                                           contentPadding: EdgeInsets.symmetric(
//                                               vertical: 10, horizontal: 10),
//                                           border: InputBorder.none),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 50),
//                                   GestureDetector(
//                                     onTap: () async {
//                                       if (access.imageUrl != null) {
//                                         await chatRoom.addMessage(
//                                             '',
//                                             widget.usermail,
//                                             context,
//                                             widget.mail,
//                                             chatdoc,
//                                             access.imageUrl.toString(),
//                                             _controller.text);

//                                         _controller.clear();
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: 100,
//                                       decoration: BoxDecoration(
//                                           color: Colors.deepPurple,
//                                           borderRadius:
//                                               BorderRadius.circular(20)),
//                                       child: const Icon(
//                                         color: Colors.white,
//                                         Icons.send,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.camera,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(125, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: TextField(
//                             maxLines: null,
//                             controller: chatcontroller,
//                             textCapitalization: TextCapitalization.sentences,
//                             decoration: const InputDecoration(
//                                 hintText: 'Message',
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 10),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 7),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.deepPurple,
//                             borderRadius: BorderRadius.circular(50)),
//                         child: IconButton(
//                           color: Colors.white,
//                           onPressed: () async {
//                             if (chatcontroller.text != '') {
//                               chatRoom.addMessage(
//                                   chatcontroller.text,
//                                   widget.usermail,
//                                   context,
//                                   widget.mail,
//                                   chatdoc,
//                                   '',
//                                   '');
//                             }

//                             chatcontroller.clear();
//                           },
//                           icon: const Icon(Icons.send),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: Text(
//           widget.usermail,
//           style: const TextStyle(letterSpacing: 5, color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:mechat/controllers/access_controller.dart';
// import 'package:mechat/controllers/message_controller.dart';
// import 'package:mechat/widgets/chat_bubble.dart';
// import 'package:mechat/widgets/chat_image_bubble.dart';

// class ChatScreen extends StatefulWidget {
//   final String usermail;
//   final String mail;
//   const ChatScreen({required this.usermail, Key? key, required this.mail})
//       : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
// class _ChatScreenState extends State<ChatScreen> {
//   TextEditingController chatcontroller = TextEditingController();
//   final TextEditingController _controller = TextEditingController();
//   String? translatedText;
//   // Define an instance of AccessStorage
//   AccessStorage access = AccessStorage(); // Make sure to adjust this based on your actual AccessStorage implementation
//   ChatRoomController chatRoom = ChatRoomController();
// // Then, you can use access.getAccess(context) and access.imageUrl as needed in your code

//   // Your AWS credentials
//   final String accessKey = 'AKIAVRUVVWVGD5TLI2G3';
//   final String secretKey = 'bLBXcMB3Pk52psBvloDWipmbAdOFXfx9dWemwl/r';
  
  

//   @override
//   Widget build(BuildContext context) {
//     // Your existing UI code
//     List ids = [widget.usermail, widget.mail];

//     ids.sort();
//     String chatdoc = ids.join("_");

//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 183, 165, 245),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chatroom')
//             .doc(chatdoc)
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CupertinoActivityIndicator());
//           } else {
//             return Column(
//               children: [
//                 Expanded(
//                   child: ListView.builder(
//                     reverse: true,
//                     itemCount: snapshot.data!.docs.length,
//                     itemBuilder: (context, index) {
//                       String currentUser =
//                           FirebaseAuth.instance.currentUser!.uid;
//                       final DocumentSnapshot documentSnapshot =
//                           snapshot.data!.docs[index];

//                       final isCurrentUser =
//                           documentSnapshot['useruid'] == currentUser;

//                       return Column(
//                         children: [
//                           ChatBubble(
//                               chatMsg: documentSnapshot['message'],
//                               isCurrentUser: isCurrentUser),
//                           ChatImageBubble(
//                               chatImage: documentSnapshot['imageurl'],
//                               isCurrentUser: isCurrentUser,
//                               caption: documentSnapshot['caption']),
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding:
//                       const EdgeInsets.only(left: 7, right: 10, bottom: 10),
//                   child: Row(
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           access.getAccess(context);

//                           showModalBottomSheet(
//                             backgroundColor:
//                                 const Color.fromARGB(255, 183, 165, 245),
//                             context: context,
//                             builder: (context) {
//                               return Column(
//                                 children: [
//                                   const SizedBox(height: 50),
//                                   Center(
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         access.getAccess(context);
//                                         showDialog(
//                                           context: context,
//                                           builder: (context) {
//                                             return AlertDialog(
//                                               content: SizedBox(
//                                                 height: 150,
//                                                 child: Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceAround,
//                                                   children: [
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         access.pickImage(
//                                                             ImageSource.camera);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const ListTile(
//                                                         leading:
//                                                             Icon(Icons.camera),
//                                                         title: Text('Camera'),
//                                                       ),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         access.pickImage(
//                                                             ImageSource
//                                                                 .gallery);
//                                                         Navigator.pop(context);
//                                                       },
//                                                       child: const ListTile(
//                                                         leading:
//                                                             Icon(Icons.photo),
//                                                         title: Text('Gallery'),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                             );
//                                           },
//                                         );
//                                       },
//                                       child: Container(
//                                         height: 100,
//                                         width: 100,
//                                         decoration: BoxDecoration(
//                                           color: Colors.white,
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                           boxShadow: [
//                                             BoxShadow(
//                                               color:
//                                                   Colors.grey.withOpacity(0.5),
//                                               spreadRadius: 0.1,
//                                               blurRadius: 7,
//                                             )
//                                           ],
//                                         ),
//                                         child: const Icon(
//                                             Icons.camera_alt_outlined),
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 50),
//                                   Container(
//                                     height: 50,
//                                     width: 250,
//                                     decoration: BoxDecoration(
//                                       color: const Color.fromARGB(
//                                           125, 255, 255, 255),
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: TextField(
//                                       maxLines: null,
//                                       controller: _controller,
//                                       textCapitalization:
//                                           TextCapitalization.sentences,
//                                       decoration: const InputDecoration(
//                                           hintText: 'Caption',
//                                           contentPadding: EdgeInsets.symmetric(
//                                               vertical: 10, horizontal: 10),
//                                           border: InputBorder.none),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 50),
//                                   GestureDetector(
//                                     onTap: () async {
//                                       if (access.imageUrl != null) {
//                                         await chatRoom.addMessage(
//                                             '',
//                                             widget.usermail,
//                                             context,
//                                             widget.mail,
//                                             chatdoc,
//                                             access.imageUrl.toString(),
//                                             _controller.text);

//                                         _controller.clear();
//                                         Navigator.pop(context);
//                                       }
//                                     },
//                                     child: Container(
//                                       height: 50,
//                                       width: 100,
//                                       decoration: BoxDecoration(
//                                           color: Colors.deepPurple,
//                                           borderRadius:
//                                               BorderRadius.circular(20)),
//                                       child: const Icon(
//                                         color: Colors.white,
//                                         Icons.send,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         },
//                         icon: const Icon(
//                           Icons.camera,
//                           color: Colors.deepPurple,
//                         ),
//                       ),
//                       Expanded(
//                         child: Container(
//                           height: 50,
//                           decoration: BoxDecoration(
//                             color: const Color.fromARGB(125, 255, 255, 255),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: TextField(
//                             maxLines: null,
//                             controller: chatcontroller,
//                             textCapitalization: TextCapitalization.sentences,
//                             decoration: const InputDecoration(
//                                 hintText: 'Message',
//                                 contentPadding: EdgeInsets.symmetric(
//                                     vertical: 10, horizontal: 10),
//                                 border: InputBorder.none),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 7),
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.deepPurple,
//                             borderRadius: BorderRadius.circular(50)),
//                         child: IconButton(
//                           color: Colors.white,
//                           onPressed: () async {
//                             if (chatcontroller.text != '') {
//                               chatRoom.addMessage(
//                                   chatcontroller.text,
//                                   widget.usermail,
//                                   context,
//                                   widget.mail,
//                                   chatdoc,
//                                   '',
//                                   '');
//                             }

//                             chatcontroller.clear();
//                           },
//                           icon: const Icon(Icons.send),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         title: Text(
//           widget.usermail,
//           style: const TextStyle(letterSpacing: 5, color: Colors.white),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//         ),
//       ),
//     );
//     // Button to initiate translation
//     ElevatedButton(
//       onPressed: () {
//         if (chatcontroller.text.isNotEmpty) {
//           translateText(chatcontroller.text);
//         }
//       },
//       child: Text('Translate'),
//     );
  

//     // Display translated text
//     if (translatedText != null)
//       Text('Translated Text: $translatedText');
//   }

//   // Method to translate text using Amazon Translate API
//   Future<void> translateText(String text) async {
//     final String endpoint =
//         'https://translate.eu-north-1.amazonaws.com'; // Change the endpoint based on your AWS region

//     final String sourceLanguageCode = 'en'; // Source language code
//     final String targetLanguageCode = 'es'; // Target language code

//     final Map<String, dynamic> requestBody = {
//       'Text': text,
//       'SourceLanguageCode': sourceLanguageCode,
//       'TargetLanguageCode': targetLanguageCode,
//     };

//     final String requestUrl = '$endpoint/?Action=TranslateText&'
//         'Version=2017-07-01&'
//         'Text=${Uri.encodeQueryComponent(requestBody['Text'])}&'
//         'SourceLanguageCode=${requestBody['SourceLanguageCode']}&'
//         'TargetLanguageCode=${requestBody['TargetLanguageCode']}';

//     final Uri uri = Uri.parse(requestUrl);

//     final response = await http.post(
//       uri,
//       headers: {
//         'Content-Type': 'application/x-www-form-urlencoded',
//       },
//       body: {
//         // Your AWS credentials
//         'AWSAccessKeyId': accessKey,
//         'AWSSecretKey': secretKey,
//       },
//     );

//     if (response.statusCode == 200) {
//       final Map<String, dynamic> responseData = json.decode(response.body);
//       setState(() {
//         translatedText = responseData['TranslatedText'];
//       });
//     } else {
//       // Handle error
//       print('Failed to translate text: ${response.reasonPhrase}');
//     }
//   }
// }

// Import necessary packages
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  String? translatedText;

  // Your AWS credentials
  final String accessKey = 'AKIAVRUVVWVGD5TLI2G3';
  final String secretKey = 'bLBXcMB3Pk52psBvloDWipmbAdOFXfx9dWemwl/r';

  String selectedLanguage = 'en'; // Default language is English

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.usermail),
      ),
      body: Column(
        children: [
          // Language selection dropdown
          DropdownButton<String>(
            value: selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
            },
            items: <String>['en', 'hi']
                .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value == 'en' ? 'English' : 'Hindi'),
                  ),
                )
                .toList(),
          ),
          // Text input field
          TextField(
            controller: chatcontroller,
            decoration: InputDecoration(
              hintText: 'Enter text',
            ),
          ),
          // Translate button
          ElevatedButton(
            onPressed: () {
              if (chatcontroller.text.isNotEmpty) {
                translateText(chatcontroller.text);
              }
            },
            child: Text('Translate'),
          ),
          // Display translated text
          if (translatedText != null)
            Text('Translated Text: $translatedText'),
        ],
      ),
    );
  }

  // Method to translate text using Amazon Translate API
  Future<void> translateText(String text) async {
    final String endpoint =
        'https://translate.eu-north-1.amazonaws.com'; // Change the endpoint based on your AWS region

    final String sourceLanguageCode = selectedLanguage;
    final String targetLanguageCode =
        selectedLanguage == 'en' ? 'hi' : 'en'; // Target language is opposite of source language

    final Map<String, dynamic> requestBody = {
      'Text': text,
      'SourceLanguageCode': sourceLanguageCode,
      'TargetLanguageCode': targetLanguageCode,
    };

    final String requestUrl = '$endpoint/?Action=TranslateText&'
        'Version=2017-07-01&'
        'Text=${Uri.encodeQueryComponent(requestBody['Text'])}&'
        'SourceLanguageCode=${requestBody['SourceLanguageCode']}&'
        'TargetLanguageCode=${requestBody['TargetLanguageCode']}';

    final Uri uri = Uri.parse(requestUrl);

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        // Your AWS credentials
        'AWSAccessKeyId': accessKey,
        'AWSSecretKey': secretKey,
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      setState(() {
        translatedText = responseData['TranslatedText'];
      });
    } else {
      // Handle error
      print('Failed to translate text: ${response.reasonPhrase}');
    }
  }
}
