import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:workhouse/utils/constant.dart';

class AppVideoPlayer extends StatefulWidget {
  final dynamic sourceFile;
  final dynamic sourceURL;

  const AppVideoPlayer({
    Key? key,
    this.sourceFile,
    this.sourceURL,
  }) : super(key: key);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    if (widget.sourceURL.isNotEmpty) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          widget.sourceURL,
        ),
      );
    } else {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(
          'https://lgkqpwmgwwexlxfnvoyp.supabase.co/storage/v1/object/public/community/1724233507205',
        ),
      );
    }

    _initializeVideoPlayerFuture = _controller.initialize();

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
        borderRadius: BorderRadius.circular(16),
      ),
      child: _controller.value.isInitialized
          ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
          : Container(
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
    );
  }
}
