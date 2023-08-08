import 'dart:async';

import 'package:event_app/bloc/event_bloc.dart';
import 'package:event_app/models/common_response.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:video_player/video_player.dart';
import 'package:dio/dio.dart' as dio ;

class VideoWishSendScreen extends StatefulWidget {
  final String path;
  final int participantId;
  VideoWishSendScreen({required this.path, required this.participantId});

  @override
  _VideoWishSendScreenState createState() => _VideoWishSendScreenState();
}

class _VideoWishSendScreenState extends State<VideoWishSendScreen> {
  VideoPlayerController? _videoPlayerController;
  TextEditingController _captionController = TextEditingController();

  EventBloc _bloc= EventBloc();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      File file = File(widget.path);
        _videoPlayerController = VideoPlayerController.file(file)
          ..setLooping(true)
          ..initialize().then((_) {
            setState(() {});
          });

    });
  }

   @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: secondaryColor.shade50,
        appBar: AppBar(),
        body: WillPopScope(
          onWillPop: () async {
            await _videoPlayerController!.pause();
            await _videoPlayerController!.dispose();
            Get.back();
            return false;
          },
          child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[

                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: _videoPlayerController == null
                      ?Container()
                        :  GestureDetector(
                      onTap: () async {
                         _videoPlayerController!.value.isPlaying
                            ? await _videoPlayerController!.pause()
                            : await _videoPlayerController!.play();
                        setState(() { });
                      },
                    child: AspectRatio(
                      aspectRatio: _videoPlayerController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          VideoPlayer(_videoPlayerController!),
                          _videoPlayerController!.value.isPlaying
                          ? SizedBox()
                          : Center(child: Icon(Icons.play_arrow,color: Colors.white,size: 70,)),
                          VideoProgressIndicator(_videoPlayerController!, allowScrubbing: true,padding: EdgeInsets.all(12),),
                        ],
                      ),
                    ),
                    )
                  ),
                ),

            Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[

                          Expanded(
                            child: TextField(
                              minLines: 1,
                              maxLines: 3,
                              maxLength: 200,
                            controller: _captionController,
                            decoration: new InputDecoration(
                              hintText: "Add a Caption"
                            ),
                          ),
                          ),

                          SizedBox(
                            width: 10,
                          ),

                          InkWell(
                            onTap: _sendVideo,
                            child: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: primaryColor.shade500,
                                borderRadius: BorderRadius.circular(10.0),
                              ),

                             child:  Icon(Icons.send,color: Colors.white)
                            ),
                          ),



                        ],
                      )
                    )))
          ]),
        ));
  }

    Future _sendVideo() async {
      await _videoPlayerController!.pause();
      AppDialogs.loading();
    File? file = File(widget.path);
    try {
      Map<String,dynamic> body = {
            'video' : await dio.MultipartFile.fromFile(file.path),
            'event_participant_id' : widget.participantId,
            'caption' : '${_captionController.text}'
        };

      dio.FormData formData = dio.FormData.fromMap(body);

      CommonResponse response = await _bloc.sendVideo(formData);
      
      if (response.success!) {
toastMessage('${response.message}');
Get.close(3);
      } else {
        toastMessage('${response.message!}');
        Get.back();
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      Get.back();
      toastMessage('Something went wrong. Please try again');
    }
  }

}


// class _ControlsOverlay extends StatelessWidget {
//   const _ControlsOverlay({Key? key, required this.controller})
//       : super(key: key);
//
//   static const _examplePlaybackRates = [
//     0.25,
//     0.5,
//     1.0,
//     1.5,
//     2.0,
//     3.0,
//     5.0,
//     10.0,
//   ];
//
//   final VideoPlayerController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: Duration(milliseconds: 50),
//           reverseDuration: Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//             ? SizedBox.shrink()
//             : Container(
//           color: Colors.black26,
//           child: Center(
//             child: Icon(
//               Icons.play_arrow,
//               color: Colors.white,
//               size: 100.0,
//             ),
//           ),
//         ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//         Align(
//           alignment: Alignment.topRight,
//           child: PopupMenuButton<double>(
//             initialValue: controller.value.playbackSpeed,
//             tooltip: 'Playback speed',
//             onSelected: (speed) {
//               controller.setPlaybackSpeed(speed);
//             },
//             itemBuilder: (context) {
//               return [
//                 for (final speed in _examplePlaybackRates)
//                   PopupMenuItem(
//                     value: speed,
//                     child: Text('${speed}x'),
//                   )
//               ];
//             },
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 // Using less vertical padding as the text is also longer
//                 // horizontally, so it feels like it would need more spacing
//                 // horizontally (matching the aspect ratio of the video).
//                 vertical: 12,
//                 horizontal: 16,
//               ),
//               //child: Text('${controller.value.playbackSpeed}x'),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
