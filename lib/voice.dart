import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  List<String> languages = ['Select', 'English', 'French', 'Hindi', 'German']; // Adjusted languages list
  String selectedLanguage1 = 'Select'; // Default selection for the first dropdown
  String selectedLanguage2 = 'Select'; // Default selection for the second dropdown

  void translateText(String text) async {
    String toLanguage = 'en'; // Default translation language to English
    if (selectedLanguage1 == 'English' && selectedLanguage2 == 'Hindi') {
      toLanguage = 'hi';
    } else if (selectedLanguage1 == 'Hindi' && selectedLanguage2 == 'English') {
      toLanguage = 'en';
    } else if (selectedLanguage1 == 'English' && selectedLanguage2 == 'French') {
      toLanguage = 'fr';
    } else if (selectedLanguage1 == 'French' && selectedLanguage2 == 'English') {
      toLanguage = 'en';
    } else if (selectedLanguage1 == 'English' && selectedLanguage2 == 'German') {
      toLanguage = 'de';
    } else if (selectedLanguage1 == 'German' && selectedLanguage2 == 'English') {
      toLanguage = 'en';
    }
    Translation translation = await translator.translate(text, to: toLanguage);
    setState(() {
      translatedText = translation.text;
    });
  }

  void startListening() async {
    if (languages.contains(selectedLanguage1) && languages.contains(selectedLanguage2)) {
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
    } else {
      // Optionally, you can display a message or handle the case when the selected languages are not in the supported list.
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
        backgroundColor: Color.fromARGB(255, 83, 34, 223),
        title: Text(
          'Voice Translation',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
            colors: [Color.fromARGB(255, 83, 34, 223), Colors.white],
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
                  color: Colors.white,
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
                  color: Color.fromARGB(255, 205, 198, 231),
                  borderRadius: BorderRadius.circular(10.0), // Rounded edges
                ),
                child: Center(
                  child: Text(
                    translatedText,
                    style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () {
                  flutterTts.setLanguage('hi-IN'); // Set the language to Hindi
                  flutterTts.speak(translatedText);
                },
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
        color: Color.fromARGB(255, 77, 73, 124),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: DropdownButton<String>(
        value: selectedValue,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Color.fromARGB(255, 134, 129, 186)),
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
