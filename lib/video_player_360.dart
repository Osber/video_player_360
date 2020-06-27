import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoPlayer360 {
  static const MethodChannel _channel =
      const MethodChannel('innov.lab/video_player_360');

  MethodChannel _playerChannel;

  VideoPlayer360.init(int id) {
    _playerChannel = new MethodChannel('player360_$id');
  }

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///
  /// Set spherical mesh for the texture. The mesh does not have be closed.
  ///
  /// @param radius Size of the sphere in meters. Must be > 0.
  /// @param verticalFov Total latitudinal degrees that are covered by the sphere. Must be in (0, 180].
  /// @param horizontalFov Total longitudinal degrees that are covered by the sphere.Must be in (0, 360].
  /// @param rows Number of rows that make up the sphere. Must be >= 1.
  /// @param columns Number of columns that make up the sphere. Must be >= 1.
  ///
  ///

  Future<void> playVideo() async {
    return _playerChannel.invokeMethod("play");
  }

  Future<dynamic> stopVideo() async {
    return _playerChannel.invokeMethod("closeplayer");
  }

  Future<dynamic> getVideoScreen(
    String url, {
    int radius = 50,
    int verticalFov = 180,
    int horizontalFov = 360,
    int rows = 50,
    int columns = 50,
    bool showPlaceholder = false,
  }) async {
    try {
      final result =
          await _playerChannel.invokeMapMethod("playvideo", <String, dynamic>{
        'video_url': url,
        'radius': radius,
        'verticalFov': verticalFov,
        'horizontalFov': horizontalFov,
        'rows': rows,
        'columns': columns,
        'showPlaceholder': showPlaceholder,
      });
      return result;
    } on PlatformException catch (e) {
      return "Error from video player: '${e.message}'.";
    }
  }

  static Future<void> playVideoURL(
    String url, {
    int radius = 50,
    int verticalFov = 180,
    int horizontalFov = 360,
    int rows = 50,
    int columns = 50,
    bool showPlaceholder = false,
  }) async {
    assert(url != null);
    return _channel.invokeMapMethod("playvideo", <String, dynamic>{
      'video_url': url,
      'radius': radius,
      'verticalFov': verticalFov,
      'horizontalFov': horizontalFov,
      'rows': rows,
      'columns': columns,
      'showPlaceholder': showPlaceholder,
    });
  }
}

typedef void PlayerViewCreatedCallback(VideoPlayer360 controller);

class Player360Widget extends StatefulWidget {
  final PlayerViewCreatedCallback onPlayerCreated;

  Player360Widget({
    Key key,
    @required this.onPlayerCreated,
  });

  @override
  _Player360WidgetState createState() => _Player360WidgetState();
}

class _Player360WidgetState extends State<Player360Widget> {
  @override
  Widget build(BuildContext context) {
    Future<void> onPlatformViewCreated(id) async {
      if (widget.onPlayerCreated == null) {
        return;
      }
      widget.onPlayerCreated(new VideoPlayer360.init(id));
    }

    if (Platform.isAndroid) {
      // return AndroidView();
    } else if (Platform.isIOS) {
      return UiKitView(
        viewType: 'player360',
        onPlatformViewCreated: onPlatformViewCreated,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }

    return new Text('This is not yet supported by this plugin');
  }
}
