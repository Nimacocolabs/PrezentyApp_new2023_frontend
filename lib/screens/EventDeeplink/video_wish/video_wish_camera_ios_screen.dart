import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:event_app/screens/EventDeeplink/video_wish/video_wish_send_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class VideoWishCameraIosScreen extends StatefulWidget {
  final int participantId;
  const VideoWishCameraIosScreen({Key? key, required this.participantId}) : super(key: key);

  @override
  _VideoWishCameraIosScreenState createState() => _VideoWishCameraIosScreenState();
}

class _VideoWishCameraIosScreenState extends State<VideoWishCameraIosScreen> {

  CameraController? controller;
  List<CameraDescription> cameras=[];
  int? selectedCameraIdx;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (!await Permission.storage.request().isGranted) {
      //   debugPrint('no permission');
      //   Get.back();
      // }

        String filePath = '${(await getApplicationDocumentsDirectory()).path}/video.mp4';
        File file = File(filePath);
        //todo check error
        if(await file.exists()){
          await file.delete();
        }

     List<CameraDescription> availableCamera = await availableCameras();

        cameras = availableCamera;

        if (cameras.length > 0) {
          setState(() {
            selectedCameraIdx = 0;
          });

          await _onCameraSwitched(cameras[selectedCameraIdx!]);
        }else{
          toastMessage('Camera unavailable');
          Get.back();
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(),
      body: WillPopScope(
        onWillPop: ()async{
          await controller!.dispose();
          Get.back();
          return false;
        },
        child: cameras.isEmpty
          ?SizedBox()
        :Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
                color: Colors.black,
              ),
            ),
            Container(
              color: secondaryColor.shade900,
              padding: const EdgeInsets.all(15.0),
              child: (controller != null &&
                  controller!.value.isInitialized &&
                  !controller!.value.isRecordingVideo)
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _videoPickerButtonWidget(),
                  _captureButtonWidget(),
                  _cameraSwitchingButton()
                ],
              )
                  : Center(
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: MaterialButton(
                      onPressed: _onStopButtonPressed,
                      color: Colors.white,
                      textColor: Colors.grey,
                      child: Icon(
                        Icons.stop,
                        color: Colors.black,
                        size: 24,
                      ),
                      padding: EdgeInsets.all(16),
                      shape: CircleBorder(),
                    ),),),),
            )
          ],
        ),
      ),
    );
  }

  _pickVideo() async {
    try{
      XFile? pickedFile = await ImagePicker().pickVideo(source: ImageSource
          .gallery);
      if (pickedFile != null) {
        _goToSendVideoScreen(pickedFile.path);
      }
    }catch(e,s){
      Completer(). completeError(e,s);
      toastMessage('Unable to access photo library');
    }
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
      case CameraLensDirection.front:
        return Icons.camera_front;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  Widget _cameraPreviewWidget() {
      return CameraPreview(controller!);
  }

  Widget _captureButtonWidget() {
    return Container(
        child: Align(
            alignment: Alignment.center,
            child: MaterialButton(
              onPressed: _onRecordButtonPressed,
              color: Colors.white,
              textColor: Colors.grey,
              child: Icon(
                Icons.fiber_manual_record,
                color: Colors.red,
                size: 24,
              ),
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

  Widget _cameraSwitchingButton() {
    if (cameras.isEmpty) {
      return Row();
    }

    CameraDescription selectedCamera = cameras[selectedCameraIdx!];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Container(
      width: 50,
      height: 50,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: IconButton(
        onPressed: _onSwitchCamera,
        icon: Icon(_getCameraLensIcon(lensDirection)),
      ),
    );
  }

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller!.value.hasError) {
        Fluttertoast.showToast(
            msg: 'Camera error ${controller!.value.errorDescription}',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _onSwitchCamera() async {
      selectedCameraIdx =
      selectedCameraIdx! < cameras.length - 1 ? selectedCameraIdx! + 1 : 0;
      CameraDescription selectedCamera = cameras[selectedCameraIdx!];

      _onCameraSwitched(selectedCamera);

      setState(() {
        selectedCameraIdx = selectedCameraIdx;
      });
  }

  _onRecordButtonPressed() async {
      _startVideoRecording().then((String? filePath) {
        if (filePath != null) {
          Fluttertoast.showToast(
              msg: 'Recording video started',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.grey,
              textColor: Colors.white);
        }
      });
  }

  void _onStopButtonPressed() async {
    stopVideoRecording().then((file) async {
      if (mounted) setState(() {});
      if (file != null) {
        _goToSendVideoScreen(file.path);
      }
    });
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

  Future<String?> _startVideoRecording() async {
    // if (!await Permission.storage.request().isGranted) {
    //   debugPrint('no permission');
    //   return null;
    // }

    if (!controller!.value.isInitialized) {
      Fluttertoast.showToast(
          msg: 'Please wait',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.grey,
          textColor: Colors.white);

      return null;
    }

    if (controller!.value.isRecordingVideo) {
      return null;
    }

    String videoDirectory = (await getApplicationDocumentsDirectory()).path;

    await Directory(videoDirectory).create(recursive: true);
    final String filePath = '$videoDirectory/video.mp4';

    try {
      await controller!.startVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return e.toString();
    }
    return filePath;
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

}
