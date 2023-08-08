import 'dart:async';
import 'dart:io';

import 'package:event_app/widgets/app_dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_helper.dart';

class DownloadHelper {
  static Future<bool> load(
      BuildContext context, String url, String dir, String fileName) async {
      print(url);
      print('$dir/$fileName');

      AppDialogs.loading();
      try {
        if (!await Directory('$dir').exists()) {
          await Directory('$dir').create(recursive: true);
        }

      HttpClient httpClient = new HttpClient();
        File file;

        var request = await httpClient.getUrl(Uri.parse(url));
        var response = await request.close();

        if (response.statusCode == 200) {
          var bytes = await consolidateHttpClientResponseBytes(response);
          String filePath = '$dir/$fileName';
          file = File(filePath);
          await file.writeAsBytes(bytes);
          print('downloaded: ${file.path}');
          return true;
        } else {
          print('Error code: ${response.statusCode}');
          toastMessage('Unable to download file');
        }
      } catch (e, s) {
        Completer().completeError(e, s);
        toastMessage('Something went wrong. Please try again');
      } finally {
        Get.back();
      }
    return false;
  }
}
