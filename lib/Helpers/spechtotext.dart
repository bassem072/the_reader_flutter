import 'dart:async';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
class spechtotext  {
  var mystate;
  bool check=true;
  bool _hasSpeech = false;
  bool _stressTest = false;
  double level = 0.0;
  int _stressLoops = 0;
  String lastWords = "";
  String lastWords2 = "";
  String lastError = "";
  String lastStatus = "";
  String _currentLocaleId = "";
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
   var mycontext;
  spechtotext(var state){
    this.mystate=state;
  }

  Future<void> initSpeechState() async {
    bool hasSpeech = await speech.initialize(
        onError: errorListener, onStatus: statusListener);
    if (hasSpeech) {
      _localeNames = await speech.locales();

      var systemLocale = await speech.systemLocale();
      _currentLocaleId = systemLocale.localeId;
    }

    if (!this.mystate.mounted) return;

    this.mystate.setState(() {
      _hasSpeech = hasSpeech;
    });
  }



  void stressTest() {
    if (_stressTest) {
      return;
    }
    _stressLoops = 0;
    _stressTest = true;
    print("Starting stress test...");
    startListening();
  }

  void changeStatusForStress(String status) {
    if (!_stressTest) {
      return;
    }
    if (speech.isListening) {
      stopListening();
    } else {
      if (_stressLoops >= 100) {
        _stressTest = false;
        print("Stress test complete.");
        return;
      }
      print("Stress loop: $_stressLoops");
      ++_stressLoops;
      startListening();
    }
  }
  void work ()async{
    await initSpeechState();


    //  Future.delayed(const Duration(milliseconds: 10000), () {
    startListening();
    //  });




  }
  Future<dynamic> startListening()async {

    print( speech.listen(
        onResult:  resultListener,
        listenFor: Duration(seconds: 1000),
        localeId: _currentLocaleId,
        onSoundLevelChange: soundLevelListener,
        cancelOnError: true,
        partialResults: false));
    this.mystate.setState(() {});
    return Future((){});
  }

  void stopListening() {
    speech.stop();
    this.mystate.setState(() {
      level = 0.0;
    });
  }

  void cancelListening() {
    speech.cancel();
    this.mystate.setState(() {
      level = 0.0;
    });
  }

  void resultListener(SpeechRecognitionResult result)async {
    this.mystate.setState(() {
      this.lastWords = "${result.recognizedWords} ";
      this.check=false;

    });
  }

  void soundLevelListener(double level) {
    this.mystate.setState(() {
      this.level = level;
    });
  }


  void errorListener(SpeechRecognitionError error) {
    this.mystate.setState(() {
      lastError = "${error.errorMsg} - ${error.permanent}";
    });
  }

  void statusListener(String status) {
    changeStatusForStress(status);
    this.mystate.setState(() {
      lastStatus = "$status";
    });
  }

  _switchLang(selectedVal) {
    this.mystate.setState(() {
      _currentLocaleId = selectedVal;
    });
    print(selectedVal);
  }

}