import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';


class VoiceTranslation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator App',
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

  void translateText(String text) async {
    Translation translation = await translator.translate(text, to: 'hi'); // Translate to Hindi
    setState(() {
      translatedText = translation.text;
    });
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
        title: Text('Translator App'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20.0),
            child: Text(
              'Translated Text:',
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          Text(
            translatedText,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Speak the translated text in Hindi when the button is pressed
              flutterTts.setLanguage('hi-IN'); // Set the language to Hindi
              flutterTts.speak(translatedText);
            },
            child: Text('Speak'),
          ),
          SizedBox(height: 20.0),
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
    );
  }
}