
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';

class AppVideoThumbnail extends StatefulWidget {
  final File? videoFile;
  final String? videoFileUrl;
  const AppVideoThumbnail({Key? key, this.videoFile, this.videoFileUrl}) : super(key: key);

  @override
  _AppVideoThumbnailState createState() => _AppVideoThumbnailState();
}

class _AppVideoThumbnailState extends State<AppVideoThumbnail> {

  File? videoThumbFile;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(widget.videoFile != null) {
        videoThumbFile =
        await createVideoThumbnail(videoFile: widget.videoFile);
      }else {
        videoThumbFile =
        await createVideoThumbnail(url: '${widget.videoFileUrl}');
      }
      setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      width: screenWidth,
      height: screenWidth,
      child:  Stack(
        children: [
          if (videoThumbFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                videoThumbFile!,
                width: screenWidth,
                height: screenWidth,
                fit: BoxFit.cover,
              ),
            )
          else
            Center(
              child: SizedBox(
                  height: 40,width: 40,
                  child: CircularProgressIndicator()),
            ),
          Center(
            child: Icon(
              Icons.play_circle_fill_rounded,
              size: 50,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<File?> createVideoThumbnail(
      {File? videoFile, String? url}) async {
    try {
      print('thumb:');
      print(videoFile?.path);
      print(url);
      if(videoFile!=null) {
        Uint8List? unit8List = await VideoThumbnail.thumbnailData(
          video: videoFile.path,
          imageFormat: ImageFormat.PNG,
          maxWidth: 728,
          quality: 100,
        );
        final tempDir = await getTemporaryDirectory();
        File file = await File('${tempDir.path}/image.png').create();
        file.writeAsBytesSync(unit8List!);
        return file;
      }else if(url!=null) {
        String tempDir = (await getTemporaryDirectory()).path;
        String? filePath = await VideoThumbnail.thumbnailFile(
          video: url,
          thumbnailPath: tempDir,
          imageFormat: ImageFormat.PNG,
          maxWidth: 728,
          quality: 60,
        );
        return File('$filePath');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
    }
    return null;
  }
}
