import 'dart:io';

import 'package:event_app/models/common_response.dart';
import 'package:event_app/screens/event/create_event_progress_dialog_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/widgets/videoPlayer/video_player.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:dio/dio.dart' as dio;

class ChooseEventVideoScreen extends StatefulWidget {
  final String? selectedVideoFilePath;
  final bool isUpdateVideo;
  const ChooseEventVideoScreen({Key? key, required this.selectedVideoFilePath, this.isUpdateVideo = false}) : super(key: key);

  @override
  _ChooseEventVideoScreenState createState() => _ChooseEventVideoScreenState();
}

class _ChooseEventVideoScreenState extends State<ChooseEventVideoScreen> {
  FlickManager? flickManager;
  File? videoFile;

  @override
  void initState() {
    super.initState();

    if(EventData.templateType == null){
      _chooseVideoFile();
    } else if(EventData.templateType == TemplateType.VIDEO_URL){
      _setPreviewVideo();
    } else if (widget.selectedVideoFilePath == null) {
      _chooseVideoFile();
    } else {
      videoFile = File(widget.selectedVideoFilePath!);
      _setPreviewVideo();
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
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
              children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth,
                        maxHeight: screenWidth-16,
                        minHeight: 200,
                      ),
                      child: flickManager==null?
                          Icon(Icons.ondemand_video_rounded,color: Colors.grey,)
                          :Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                            Stack(
                                children: [
                                  VisibilityDetector(
                        key: ObjectKey(flickManager),
                        onVisibilityChanged: (visibility) {
                            if (visibility.visibleFraction == 0 && this.mounted) {
                              flickManager!.flickControlManager?.autoPause();
                            } else if (visibility.visibleFraction == 1) {
                              flickManager!.flickControlManager?.autoResume();
                            }
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FlickVideoPlayer(
                            flickManager: flickManager!,
                            flickVideoWithControls: FlickVideoWithControls(
                              videoFit: BoxFit.contain,
                              controls: FlickPortraitControls(),
                            ),
                            flickVideoWithControlsFullscreen: FlickVideoWithControls(
                              videoFit: BoxFit.fitHeight,
                              controls: FlickLandscapeControls(),
                            ),
                          ),
                        ),
                      ),
                                   Positioned(
                                      top: 0,right: 0,
                                      child: InkWell(
                                        onTap: _chooseVideoFile,
                                        borderRadius: BorderRadius.circular(8),
                                        child:Container(
                                        decoration: BoxDecoration(color: Colors.white60,borderRadius: BorderRadius.circular(6)),
                                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                                        margin: EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Icon(Icons.ondemand_video_rounded,size: 20,color: primaryColor,),
                                            SizedBox(width: 8,),
                                            Text('Change video',style: TextStyle(color: primaryColor),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                            ),
                          ),
                    ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(onPressed: (){
                          Get.back();
                        },
                          child: Text('Cancel'),),
                      )
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _setFile,
                          child: Text(widget.isUpdateVideo?'Update Video':'Choose This Video'),),
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _setFile() async {
    if(flickManager!=null){
      flickManager!.flickControlManager?.pause();
    }
    if(widget.isUpdateVideo){
      dio.FormData formData = dio.FormData.fromMap({
        'event_id': EventData.eventId,
        'video_file': await dio.MultipartFile.fromFile(videoFile!.path)
      });
      CommonResponse response = await Get.to(()=>CreateEventProgressDialogScreen(formData: formData,isUpdate: true,),opaque: false);
      if(response.success??false){
        toastMessage('Updated successfully');
      }else{
        return;
      }
    }
    EventData.templateFilePath = videoFile!.path;
    EventData.templateType = TemplateType.VIDEO_FILE;

    Get.back(result: true);
  }

  _chooseVideoFile() async {
    if(flickManager!=null){
      flickManager!.flickControlManager?.pause();
    }

    XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource
        .gallery);
    if (pickedFile != null) {
      if( getFileSizeInMb(File(pickedFile.path)) > 512){
        toastMessage('Maximum file size should be 512 mb');
      }else {
        videoFile = File(pickedFile.path);
        _setPreviewVideo();
      }
    }else{
      if(videoFile == null){
        Get.back();
      }
    }
  }

  _setPreviewVideo(){
   if(videoFile!=null) {
      flickManager = FlickManager(
        videoPlayerController: VideoPlayerController.file(videoFile!),
      );
    }else if(widget.isUpdateVideo){
     flickManager = FlickManager(
       videoPlayerController: VideoPlayerController.network('${EventData.baseUrlTemplateServerFile}${EventData.templateServerFileName}'),
     );
   }
    setState(() { });
  }

}
