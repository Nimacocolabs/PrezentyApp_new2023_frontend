import 'dart:io';

import 'package:event_app/util/app_helper.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AppVideoPlayer extends StatefulWidget {
  final String? videoFileUrl;
  final File? file;

  AppVideoPlayer({Key? key, this.videoFileUrl, this.file}) : super(key: key);

  @override
  _AppVideoPlayerState createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();
    if(widget.file != null) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(
            widget.file!),
      );
    }else if((widget.videoFileUrl??'').isNotEmpty) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.network(
            widget.videoFileUrl!),
      );
    }else {
      toastMessage('Invalid video info');
      Get.back();
      return;
    }
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,elevation: 0,
        ),
        body: SafeArea(
        child: VisibilityDetector(
          key: ObjectKey(flickManager),
          onVisibilityChanged: (visibility) {
            if (visibility.visibleFraction == 0 && this.mounted) {
              flickManager!.flickControlManager?.autoPause();
            } else if (visibility.visibleFraction == 1) {
              flickManager!.flickControlManager?.autoResume();
            }
          },
          child: Container(
            child: FlickVideoPlayer(
              flickManager: flickManager!,
              flickVideoWithControls: FlickVideoWithControls(
                videoFit: BoxFit.fitWidth,
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                videoFit: BoxFit.fitHeight,
                controls: FlickLandscapeControls(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
