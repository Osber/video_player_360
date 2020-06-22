import 'package:flutter/material.dart';
import 'package:video_player_360/video_player_360.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VideoPlayer360 playerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void onPlayerCreated(VideoPlayer360 playerController) {
      this.playerController = playerController;
      this.playerController.getVideoScreen(
          'https://video.felixsmart.com:9443/vod/_definst_/mp4:40A36BC38F2D/40A36BC38F2D1592246163170/playlist.m3u8?token=16eaa183-d548-475c-ad07-7b1c61e31dde');
    }

    void playVideo() {
      print(':c');
      playerController.getVideoScreen(
          'https://video.felixsmart.com:9443/vod/_definst_/mp4:40A36BC38F2D/40A36BC38F2D1592246163170/playlist.m3u8?token=16eaa183-d548-475c-ad07-7b1c61e31dde');
    }

    Player360Widget player360 = new Player360Widget(
      onPlayerCreated: onPlayerCreated,
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('360 Video Player Flutter'),
        ),
        body: Container(
          height: 500,
          width: 500,
          child: player360,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: playVideo,
          child: Icon(Icons.play_arrow),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
