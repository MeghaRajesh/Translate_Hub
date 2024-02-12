import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Translator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VoiceTranslator(),
    );
  }
}

class VoiceTranslator extends StatefulWidget {
  @override
  _VoiceTranslatorState createState() => _VoiceTranslatorState();
}

class _VoiceTranslatorState extends State<VoiceTranslator> {
  stt.SpeechToText _speechToText = stt.SpeechToText();
  FlutterTts flutterTts = FlutterTts();
  GoogleTranslator translator = GoogleTranslator();

  String _hindiText = '';
  String _translatedText = '';

  Future<void> _recordSound() async {
    if (await _speechToText.initialize()) {
      _speechToText.listen(
        onResult: (result) {
          setState(() {
            _hindiText = result.recognizedWords;
          });
        },
      );
    }
  }

  Future<void> _translateText() async {
    Translation translation =
        await translator.translate(_hindiText, from: 'hi', to: 'en');
    setState(() {
      _translatedText = translation.text;
    });
  }

  Future<void> _speakTranslatedText() async {
    await flutterTts.setLanguage("en-IN");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    await flutterTts.speak(_translatedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Translator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Recorded Text (Hindi): $_hindiText'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _recordSound,
              child: Text('Record Sound (Hindi)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate to English'),
            ),
            SizedBox(height: 20),
            Text('Translated Text (English): $_translatedText'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _speakTranslatedText,
              child: Text('Speak Translated Text'),
            ),
          ],
        ),
      ),
    );
  }
}
