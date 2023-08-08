
import 'dart:async';
import 'dart:io';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


enum TemplateType{
  IMAGE_FILE,
  VIDEO_FILE,
  IMAGE_URL,
  VIDEO_URL
}

class EventData{

  static String eventPath = '';
  static String tempEventPath = '';

  static Future initPath()async {
      String root = '';

      if(Platform.isAndroid){
        root = '${(await getApplicationDocumentsDirectory()).path}';
      }else{
        root = '${(await getApplicationDocumentsDirectory()).path}';
      }

      if(root.isEmpty){
        toastMessage('Unable to access storage');
        return false;
      }
      root = '$root/Event';

      print('root:$root');
    eventPath = '$root/event';
    tempEventPath = '$root/temp';
    return true;
  }

  static TemplateType? templateType;
  // static String baseUrlAudioServerFile = '';
  static String baseUrlTemplateServerFile = '';
  static String templateServerFileName = '';
  static String templateFilePath = '';

  static String? title;
  static DateTime? dateTime;
  static int eventId = 0;
  static String? createdBy = '';
  // static String? eventVideoFilePath;
  // static String? eventVideoUrl;
  // static String? eventImageUrl;
  // static String? eventImageFilePath;

  static String? eventAudioFilePath;
  static int? eventAudioId;
  // static String eventAudioUrl='';

  static init([String? _title,DateTime? _dateTime, String? _createdBy]){
    eventId=0;
    title=_title;
    dateTime = _dateTime;
    templateType = null;
    // baseUrlAudioServerFile='';
    baseUrlTemplateServerFile='';
    templateFilePath = '';
    templateServerFileName = '';
    eventAudioFilePath = null;
    eventAudioId = null;
    // eventAudioUrl = '';
    createdBy = _createdBy;
  }

  static evictImage() async {
    if(EventData.templateType == TemplateType.IMAGE_FILE) {
      File imageFile = File('${EventData.templateFilePath}');
      await FileImage(imageFile).evict();
    }
  }


}

