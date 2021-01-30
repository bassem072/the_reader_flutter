import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';



enum TtsState { playing, stopped }

class texttospeech  {
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  var mystate;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  String newVoiceText;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;


  texttospeech(var state){
    this.mystate=state;
    this.initTts();



   }

  initTts() {
    flutterTts = FlutterTts();

    _getLanguages();

    flutterTts.setStartHandler(() {
      mystate.setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      mystate.setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      mystate.setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }
  Future _getLanguages() async {
    languages = await this.flutterTts.getLanguages;
    if (this.languages != null) this.mystate.setState(() => this.languages);
  }

  Future play() async {
    print("aaaaa");
    await this.flutterTts.setVolume(this.volume);
    await this.flutterTts.setSpeechRate(this.rate);
    await this.flutterTts.setPitch(this.pitch);

    if (this.newVoiceText != null) {
      print("heloooooooooo");
      if (this.newVoiceText.isNotEmpty) {
        print(newVoiceText);
        var result = await this.flutterTts.speak(this.newVoiceText);
        if (result == 1) this.mystate.setState(() => this.ttsState = TtsState.playing);
      }
    }
  }

  Future stop() async {
    var result = await this.flutterTts.stop();
    if (result == 1) this.mystate.setState(() => this.ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    this.mystate.dispose();
    this.flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = List<DropdownMenuItem<String>>();
    for (String type in this.languages) {
      items.add(DropdownMenuItem(value: type, child: Text(type)));
    }
    return items;
  }

  void changedLanguageDropDownItem(dynamic selectedType) {
    this.mystate.setState(() {
      this.language = selectedType;
      this.flutterTts.setLanguage(this.language);
    });
  }
  void setVolume (double vol){
    mystate.setState((){this.volume=vol;});

  }
  void setpitch (double pitch){
    mystate.setState((){this.pitch=pitch;});
  }
  void setrate (double rate){
    mystate.setState((){this.rate=rate;});
  }
}