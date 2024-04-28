import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';

import 'option.dart'; // Assuming the option.dart file is in the same directory

class VoiceTranslation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Translation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TranslatorScreen(),
    );
  }
}

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  final translator = GoogleTranslator();
  final stt.SpeechToText speech = stt.SpeechToText();
  final FlutterTts flutterTts = FlutterTts();
  String translatedText = '';
  bool isListening = false;
  List<String> languages = [
    'Select ',
    'English',
    'French',
    'Hindi',
    'Arabic'
  ]; // Adjusted languages list
  String selectedLanguage1 =
      'Select '; // Default selection for the first dropdown
  String selectedLanguage2 =
      'Select '; // Default selection for the second dropdown

  void translateText(String text) async {
    // Check if both source and target languages are selected
    if (selectedLanguage1 != 'Select ' && selectedLanguage2 != 'Select ') {
      String sourceLanguageCode = ''; // Source language code
      String targetLanguageCode = ''; // Target language code

      // Set the source language code based on selectedLanguage1
      switch (selectedLanguage1) {
        case 'English':
          sourceLanguageCode = 'en';
          break;
        case 'French':
          sourceLanguageCode = 'fr';
          break;
        case 'Hindi':
          sourceLanguageCode = 'hi';
          break;
        case 'Arabic':
          sourceLanguageCode = 'ar';
          break;
        default:
          // Default to English if no language is selected
          sourceLanguageCode = 'en';
      }

      // Set the target language code based on selectedLanguage2
      switch (selectedLanguage2) {
        case 'English':
          targetLanguageCode = 'en';
          break;
        case 'French':
          targetLanguageCode = 'fr';
          break;
        case 'Hindi':
          targetLanguageCode = 'hi';
          break;
        case 'Arabic':
          targetLanguageCode = 'ar';
          break;
        default:
          // Default to English if no language is selected
          targetLanguageCode = 'en';
      }

      // Translate text from source language to target language
      Translation translation;
      // If source is German and target is English, directly translate

      // Translate using the specified source and target language codes
      translation = await translator.translate(text,
          from: sourceLanguageCode, to: targetLanguageCode);

      setState(() {
        translatedText = translation.text;
      });
    }
  }

  void startListening() async {
    if (await speech.initialize()) {
      setState(() {
        isListening = true;
      });
      speech.listen(
        onResult: (result) {
          translateText(result.recognizedWords);
        },
      );
    }
  }

  void stopListening() {
    speech.stop();
    setState(() {
      isListening = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speech.cancel();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 0, 7),
        title: Text(
          'Voice Translation',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color.fromARGB(255, 255, 254, 254)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    TranslatePage(), // Navigate back to option.dart
              ),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 252, 251, 253), Colors.white],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 1.0),
              Container(
                width: 300,
                height: 70.0,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 7, 7, 7),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildDropdown(selectedLanguage1, (String? newValue) {
                      setState(() {
                        selectedLanguage1 = newValue ?? 'Select';
                      });
                    }),
                    buildDropdown(selectedLanguage2, (String? newValue) {
                      setState(() {
                        selectedLanguage2 = newValue ?? 'Select';
                      });
                    }),
                  ],
                ),
              ),
              SizedBox(height: 70.0),
              Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 7, 7, 7),
                  borderRadius: BorderRadius.circular(10.0), // Rounded edges
                ),
                child: Center(
                  child: Text(
                    translatedText,
                    style:
                        TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  // Speak the translated text in Hindi when the button is pressed
                  flutterTts.setLanguage('hi-IN'); // Set the language to Hindi
                  flutterTts.speak(translatedText);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                child: Text('Speak'),
              ),
              SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isListening
                      ? IconButton(
                          icon: Icon(Icons.stop),
                          onPressed: stopListening,
                        )
                      : IconButton(
                          icon: Icon(Icons.mic),
                          onPressed: startListening,
                        ),
                  Text(
                    isListening ? 'Listening...' : 'Hold to Record',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropdown(String selectedValue, void Function(String?) onChanged) {
    return Container(
      width: 120,
      height: 30.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 251, 251, 252),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(Icons.arrow_drop_down, color: const Color.fromARGB(255, 8, 7, 7)),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Color.fromARGB(255, 3, 3, 3)),
        onChanged: onChanged,
        items: languages.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
