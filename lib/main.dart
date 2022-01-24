import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:jokes_teller/ad_manager.dart';
import 'home_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:share/share.dart';


void main() => runApp(MaterialApp(

  debugShowCheckedModeBanner: false,
  title: 'Nepali Jokes Teller',
  home: Home(),
));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  String appId = 'https://play.google.com/store/apps/details?id=com.cooldeveloper.nepalijokesteller';


  BannerAd _bannerAd;
  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  Future<bool> _onBackPressed() async{
    return showDialog(
        context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        backgroundColor: Colors.blue[100],
        title: Text('Are You Sure ?'),
        content: Text('Do You Want To Exit Joke Teller App'),
        actions: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: RaisedButton(
              color: Colors.blue,
              child: Text('Yes'),
              onPressed: (){
                Navigator.of(context).pop(true);
              },
            ),
          ),

          Container(
            margin: EdgeInsets.only(left: 120.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: RaisedButton(
                color: Colors.blue,
                child: Text('No'),
                onPressed: (){
                  Navigator.of(context).pop(false);
                },
              ),
            ),
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
        body: _mainWidget(),
      ),
    );
  }

  Widget _mainWidget(){
    return Container(
        color: Colors.blue[200],
      child: Column(
        children: [
          Image.asset('assets/image/image.png'),
          SizedBox(height: 50.0),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.green[400],
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> HomePage()));
                },
                child: Text('जोक्स',
                  style: TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                  ),

                ),
              ),
            ),
          ),
        ],
      )


    );
  }

  @override
  void initState() {
    _initAdMob();
    playMusic();
    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();
  }

  Future<void> _initAdMob() {
    // TODO: Initialize AdMob SDK
    return FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  }

  Future playMusic() async{
    await assetsAudioPlayer.open(Audio('assets/audio/laughingAudio.mp3'));
    await Future.delayed(Duration(seconds: 1));
    await assetsAudioPlayer.stop();
  }

}
