import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateHelper{
  static String formatDateTime(DateTime dt, String format){
    return DateFormat(format).format(dt);
  }
  static DateTime getDateTime(String datetime){
    return DateTime.parse(datetime);
  }
  static DateTime getDate(DateTime dt){
    return DateTime(dt.year,dt.month,dt.day);
  }


  static Future<DateTime> pickDate(BuildContext context, DateTime date) async {
    DateTime cDate=date;
    await showModalBottomSheet(context: context, builder: (context){
      return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Date',
                  style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(
                  onPressed: (){
               cDate=date;
                  Navigator.pop(context);
                }, child: Text('OK'),
                ),
              ],
            ),
          ),
          Divider(height: 1,),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: date,
              onDateTimeChanged: (DateTime dateTime) {
                date = dateTime;
              },
            ),
          ),
        ],
      );
    });
    return cDate;
  }

  static Future<DateTime> pickTime(BuildContext context, DateTime date) async {
    DateTime cDate= date;
    await showModalBottomSheet(context: context, builder: (context){
      return  Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Time',
                  style: TextStyle( fontSize: 16, fontWeight: FontWeight.w500),
                ),
                ElevatedButton(onPressed: (){
                   cDate = date;
                  Navigator.pop(context);
                }, child: Text('OK'),
                ),
              ],
            ),
          ),
          Divider(height: 1,),
          SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: date,
              onDateTimeChanged: (DateTime dateTime) {
                date = dateTime;
              },
            ),
          ),
        ],
      );
    });
    return cDate;
  }
}

