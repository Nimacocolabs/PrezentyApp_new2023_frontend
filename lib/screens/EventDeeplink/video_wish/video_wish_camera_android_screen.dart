import 'dart:async';
import 'dart:io';
import 'package:event_app/screens/EventDeeplink/video_wish/video_wish_send_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';

class VideoWishCameraAndroidScreen extends StatefulWidget {
  final int participantId;

  const VideoWishCameraAndroidScreen({Key? key, required this.participantId})
      : super(key: key);

  @override
  _VideoWishCameraAndroidScreenState createState() {
    return _VideoWishCameraAndroidScreenState();
  }
}

class _VideoWishCameraAndroidScreenState extends State<VideoWishCameraAndroidScreen>
    with WidgetsBindingObserver {
  var platformMethodChannel = const MethodChannel('app_channel');

  @override
  void dispose() {
      WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (!await Permission.storage.request().isGranted) {
      //   toastMessage('Storage permission is required');
      //   Get.back();
      // }

      String root = '${(await getExternalStorageDirectory())!.path}/Camera';
      Directory(root).create(recursive: true);

        String filePath =
            '$root/video.mp4';
        File file = File(filePath);
      if(file.existsSync()){
        await file.delete();
      }
      WidgetsBinding.instance.addObserver(this);
    });
  }

  _pickVideo() async {
  try{
    XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource
    .gallery);
    if (pickedFile != null) {
      _goToSendVideoScreen(pickedFile.path);
    }
  }catch(e,s){
    Completer().completeError(e,s);
    toastMessage('Unable to access storage');
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              child: Center(
                child: GestureDetector(
                  onTap: ()async{
                    await _androidStartCamera();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Tap',style: TextStyle(color: Colors.white,),),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(30)),
                          child: Icon(Icons.videocam,color: Colors.red,size: 18,),
                          padding: EdgeInsets.all(8),
                        ),
                        Text('to record video',style: TextStyle(color: Colors.white,),),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: secondaryColor.shade900,
            padding: const EdgeInsets.all(15.0),
            child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      _videoPickerButtonWidget(),
                      _captureButtonWidget(),
                    ],
                  )
          )
        ],
      ),
    );
  }

  Widget _captureButtonWidget() {
    return Container(
        child: Align(
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: ()async{
                await _androidStartCamera();
              },
              color: Colors.white,
              textColor: Colors.grey,
              child: Icon(Icons.videocam,color: Colors.red,size: 24,),
              padding: EdgeInsets.all(16),
              shape: CircleBorder(),
            )));
  }

  Widget _videoPickerButtonWidget() {
    return InkWell(
      onTap: () {
        _pickVideo();
      },
      child: Container(
        width: 50,
        height: 50,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Icon(
          Icons.video_collection, //photo_library
          size: 24,
        ),
      ),
    );
  }

  _androidStartCamera()async {
    try{
      await platformMethodChannel.invokeMethod("recordVideoWish");
    }
    catch(e,s){
      Completer().completeError(e,s);
      toastMessage(e.toString());
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (mounted) {
        _androidRecordCompleted();
      }
    }
  }

  _androidRecordCompleted() async {
   try{
     String filePath = '${(await getExternalStorageDirectory())!.path}/Camera/video.mp4';
     File file = File(filePath);
     if (file.existsSync()) {
       _goToSendVideoScreen(file.path);
     }
   }catch(e,s){
     Completer().completeError(e,s);
     toastMessage(e.toString());
    }
  }

  _goToSendVideoScreen(String path) async {
    if( getFileSizeInMb(File(path)) > 512){
      toastMessage('Maximum file size should be 512 mb');
    }else {
      Get.to(() => VideoWishSendScreen(
            path: path,
            participantId: widget.participantId,
          ));
    }
  }

}
