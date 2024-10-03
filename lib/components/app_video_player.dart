import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workhouse/utils/constant.dart';

class AppVideoPlayer extends StatefulWidget {
  final dynamic type;
  final dynamic source;

  const AppVideoPlayer({
    Key? key,
    required this.type,
    required this.source,
  }) : super(key: key);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  late FlickManager flickManager;

  void replay() {
    flickManager.flickControlManager!.play();
  }

  @override
  void initState() {
    if (widget.type == "url") {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.source,
        ),
      );
      flickManager = FlickManager(
        autoPlay: true,
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(
            widget.source,
          ),
        ),
        onVideoEnd: () {
          replay();
        },
      );
    } else if (widget.type == "file") {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/community/1724233507205',
        ),
      );
      flickManager = FlickManager(
        autoPlay: true,
        videoPlayerController: VideoPlayerController.file(
          widget.source,
        ),
        onVideoEnd: () {
          replay();
        },
      );
    }

    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: FlickVideoPlayer(flickManager: flickManager),
      // child: _controller.value.isInitialized
      //     ? AspectRatio(
      //         aspectRatio: _controller.value.aspectRatio,
      //         // child: VideoPlayer(_controller),
      //         child: FlickVideoPlayer(flickManager: flickManager),
      //       )
      //     : Container(
      //         child: Center(
      //           child: Container(
      //             width: 40,
      //             height: 40,
      //             child: CircularProgressIndicator(
      //               color: Colors.white,
      //             ),
      //           ),
      //         ),
      //       ),
    );
  }
}
