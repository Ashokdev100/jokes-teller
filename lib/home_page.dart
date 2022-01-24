import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jokes_teller/jokes_collection.dart';
import 'package:jokes_teller/jokes_collection.dart';
import 'package:share/share.dart';

import 'ad_manager.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  JokesCollection jokesCollection = JokesCollection();
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  FlutterTts flutterTts = FlutterTts();
  Widget textOrGif;
  bool isCompleted = false;
  int index = 0;
  bool isClickAvailable=false;

  // TODO: Add _interstitialAd
  InterstitialAd _interstitialAd;

  // TODO: Add _isInterstitialAdReady
  bool _isInterstitialAdReady;

  // TODO: Implement _loadInterstitialAd()
  void _loadInterstitialAd() {
    _interstitialAd.load();
  }

  // TODO: Implement _onInterstitialAdEvent()
  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        _isInterstitialAdReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        _isInterstitialAdReady = false;
        print('Failed to load an interstitial ad');
        break;
      case MobileAdEvent.closed:
        break;
      default:
      // do nothing
    }
  }


  List<String> randomJokes;
  Random random = Random();
  String appId = 'https://play.google.com/store/apps/details?id=com.cooldeveloper.nepalijokesteller';


  @override
  void initState() {

    _isInterstitialAdReady = false;

    // TODO: Initialize _interstitialAd
    _interstitialAd = InterstitialAd(
      adUnitId: AdManager.interstitialAdUnitId,
      listener: _onInterstitialAdEvent,
    );

    super.initState();
    print(jokesCollection.jokes);
    randomJokes = jokesCollection.jokes.toList()..shuffle();
    print(randomJokes);
    textOrGif = _buttonSection();
    flutterTts.setStartHandler(() {
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isCompleted = true;
      });

    });
    flutterTts.setCancelHandler(() {
    });
    _speak();
  }

  Future _speak() async {
    textOrGif = _buttonSection();
    if(await flutterTts.isLanguageAvailable("hi-IN")){
      await flutterTts.setLanguage("hi-IN");
    }else{
      await flutterTts.setLanguage("en-US");
    }
    await flutterTts.setSpeechRate(0.7);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.5);
    var result = await flutterTts.speak(randomJokes[index]);

    do{
      await Future.delayed(Duration(seconds: 1));
    }while(!isCompleted);

    setState(() {
      assetsAudioPlayer.open(Audio('assets/audio/laughingAudio.mp3'));
      isCompleted = false;
      textOrGif = _gifSection();
    });

    do{
      await Future.delayed(Duration(seconds: 1));

    }while(assetsAudioPlayer.isPlaying.value);

    setState(() {
      isClickAvailable = true;
      textOrGif = _buttonSection();
    });

  }

  Future stop() async{
    var result = await flutterTts.stop();

  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Nepali Jokes Teller'),
            GestureDetector(
              onTap: () {
                Share.share('$appId');
              },
              child: CircleAvatar(
                child: Icon(Icons.share),
              ),
            )
          ],
        ),
      ),
      body: textOrGif,
      );
  }

  Widget _buttonSection(){

    return Container(
      color: Colors.blue[200],
      child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                padding: EdgeInsets.all(5.0),
                child: Image.asset('assets/image/laughing.PNG')),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 300.0,
                color: Colors.green[400],
                child: Text(randomJokes[index],
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Opacity(
                opacity: isClickAvailable ? 1:0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Opacity(
                      opacity: index==0 || !isClickAvailable? 0:1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: RaisedButton.icon(
                            onPressed: () {
                                setState(() {
                                  isClickAvailable = false;
                                  index--;
                                  _speak();

                                });
                            },
                            color: Colors.blue,
                            icon: Icon(Icons.skip_previous),
                            label: Text('Previous',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                        ),

                      ),
                    ),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            isClickAvailable = false;
                            _speak();
                          });

                        },
                        child: CircleAvatar(
                          child: Icon(Icons.refresh),
                          backgroundColor: Colors.blue,
                        )
                    ),
                    Opacity(
                      opacity: index == 3 || !isClickAvailable ? 0:1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: RaisedButton.icon(
                            color: Colors.blue,
                            onPressed: () {
                                setState(() {
                                  isClickAvailable = false;
                                  index++;
                                  _speak();

                                });

                            },
                            icon: Icon(Icons.skip_next),
                            label: Text('Next',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
      ),
    );

  }

  Widget _gifSection() {
    return Container(
      child: Center(
        child: Image.asset('assets/gif/laughingEmoji.gif'),
      ),
    );
  }

  @override
  void dispose() {
    if (!_isInterstitialAdReady) {
      _loadInterstitialAd();
    }
    _interstitialAd.show();
    super.dispose();
    if(assetsAudioPlayer.isPlaying.value){
      assetsAudioPlayer.stop();
    }else{

    }
    flutterTts.stop();
  }

}
