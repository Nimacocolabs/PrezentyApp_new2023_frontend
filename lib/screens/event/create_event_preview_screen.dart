import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:event_app/models/create_event_response.dart';
import 'package:event_app/screens/event/image_editor_preview_screen.dart';
import 'package:event_app/services/dynamic_link_service.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/date_helper.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/widgets/app_video_thumbnail.dart';
import 'package:event_app/widgets/event_share_button.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:event_app/widgets/videoPlayer/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../main_screen.dart';
import 'create_event_progress_dialog_screen.dart';

class CreateEventPreviewScreen extends StatefulWidget {
  final bool isFromViewDemo;
  final bool hasAudio;

  const CreateEventPreviewScreen({required this.isFromViewDemo, this.hasAudio=false});

  @override
  _CreateEventPreviewScreenState createState() =>
      _CreateEventPreviewScreenState();
}

class _CreateEventPreviewScreenState extends State<CreateEventPreviewScreen> {
  int savedEventId = 0;
  File? imageFile;
  File? videoFile;

  @override
  void initState() {
    super.initState();

    if(widget.isFromViewDemo) savedEventId = EventData.eventId;

    if(EventData.templateType==TemplateType.VIDEO_FILE) {
      videoFile = File('${EventData.templateFilePath}');
      // setState(() { });
    }
    // else if(EventData.templateType==TemplateType.VIDEO_URL) {
      //// setState(() { });
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(EventData.templateType==TemplateType.IMAGE_FILE) {
        await EventData.evictImage();
        imageFile = File('${EventData.templateFilePath}');
        // setState(() { });
      }
     setState(() { });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: savedEventId!=0?null:[
          TextButton(
            style:ButtonStyle(
              overlayColor: MaterialStateColor.resolveWith((states) => Colors.white30),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Save for Later',style: TextStyle(color: Colors.white),),
            ),
            onPressed: (){
             _createEvent(false);
            },
          ),
        ],
      ),
      bottomNavigationBar:EventData.dateTime!.isBefore(DateTime.now())?null: Material(
        color: secondaryColor.shade300,
        child:EventShareButton(
            eventId: savedEventId,
            eventTitle: EventData.title??'',
            onTap:
            savedEventId == 0
            ? (){_createEvent(true);} : null
      ),
      ),
      body : ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(12),
        children: <Widget>[
          Text(
            EventData.title??'',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          if((EventData.createdBy??'').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                      text: 'Created by ',
                      style: const TextStyle(
                          fontSize: 14, color: Colors.grey),),
                  TextSpan(
                    text: '${EventData.createdBy}',
                    style: TextStyle(fontSize: 16,),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Icon(
                  CupertinoIcons.calendar,
                  color: primaryColor,
                  size: 22,
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                  '${DateHelper.formatDateTime(EventData.dateTime!, 'dd-MMM-yyy')}',style: TextStyle(fontSize: 16),),
              SizedBox(
                width: 20,
              ),
              Container(
                padding: EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: Icon(CupertinoIcons.time, color: primaryColor, size: 22),
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                  '${DateHelper.formatDateTime(EventData.dateTime!, 'hh:mm a')}',style: TextStyle(fontSize: 16),),
            ],
          ),
          Divider(
            height: 32,
          ),
   AspectRatio(
     aspectRatio: 1/1,
     child: Container(
          decoration: BoxDecoration(
            // color: Colors.black45,
              borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
          width: screenWidth,
          height: screenWidth,
          child: _buildPreviewImage()
            ),
   ),

          EventData.eventAudioFilePath == null
              ?Container()
              :Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TitleWithSeeAllButton(title: 'Music'),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 12),
                elevation: 2,
                child: ListTile(
                  contentPadding: EdgeInsets.all(8),
                  leading:Container(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.music_note),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  title: Text('${EventData.eventAudioFilePath!.substring(EventData.eventAudioFilePath!.lastIndexOf('/')+1)}',maxLines: 1,overflow: TextOverflow.ellipsis,),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _buildPreviewImage(){
    if(EventData.templateType==TemplateType.VIDEO_URL||EventData.templateType==TemplateType.VIDEO_FILE){
      //my event detail preview or create video preview
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // one will be null
          Get.to(() => AppVideoPlayer(
            file: videoFile, videoFileUrl: '${EventData.baseUrlTemplateServerFile}${EventData.templateServerFileName}',
          ));
        },
        child: AppVideoThumbnail(videoFile:videoFile,videoFileUrl: '${EventData.baseUrlTemplateServerFile}${EventData.templateServerFileName}',)
      );
    }else if(imageFile != null){
      // event create image preview
      return InkWell(
          onTap: !widget.isFromViewDemo
              ? null
              : () {
            Get.to(() => ImageEditorPreviewScreen(
              imagePath: imageFile!.path,
              hasAudio: widget.hasAudio,
            ));
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                imageFile!,
                fit: BoxFit.contain,
              )));
    }else{
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }


  Future _createEvent(bool needShare) async {
    try {

      Map<String, dynamic> body = {
        'title': EventData.title,
        'date': DateHelper.formatDateTime(EventData.dateTime!, 'dd-MMM-yyyy'),
        'time': DateHelper.formatDateTime(EventData.dateTime!, 'HH:mm'),
        'created_by': EventData.createdBy??'',
        'gift_voucher_ids': '',
        'food_vouchers_ids[]': [],
        'music_file_id': EventData.eventAudioId,
        'music_file': (EventData.eventAudioFilePath ?? '').isEmpty
            ? null
            : await dio.MultipartFile.fromFile(
                '${EventData.eventAudioFilePath}'),
      };
      if(EventData.templateType==TemplateType.IMAGE_FILE){
        body['image'] = await dio.MultipartFile.fromFile('${EventData.templateFilePath}');
      } else {
          body['video_file'] = await dio.MultipartFile.fromFile('${EventData.templateFilePath}');
      }

      dio.FormData formData = dio.FormData.fromMap(body);

      // CreateEventResponse response = await _bloc.createEvent(formData);
      CreateEventResponse? response = await Get.to(()=>CreateEventProgressDialogScreen(formData: formData,isUpdate:false),opaque: false);

      if(response==null) return;

      if (response.success??false) {
        toastMessage('${response.message}');

        if(needShare){
            _share(response.detail!.id!,response.detail!.imageUrl,EventData.title??'');
        }
        Get.offAll(MainScreen());

      } else {
        toastMessage('${response.message??'something went wrong'}');
      }
    } catch (e, s) {
      Completer().completeError(e, s);
      toastMessage('Something went wrong. Please try again');
    }
  }

  _share (int id,String? eventImageUrl,String eventTitle) async {
    Uri url = await DynamicLinkService().createDynamicLink( id,  'https://prezenty.in/prezenty/common/uploads/event-images/$eventImageUrl',  eventTitle);
    log(url.toString());
    await Share.share('You are invited to this ${eventTitle}\n\n${url.toString()}');
  }

  getImage(String? baseUrl, String? imageUrl) {
    String img = "";
    if (baseUrl != null && imageUrl != null) {
      if (baseUrl != "" && imageUrl != "") {
        img = baseUrl + imageUrl;
      }
    }
    return img;
  }
}


