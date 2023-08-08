import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';

class CommonApiErrorWidget extends StatelessWidget {
  final String text;
  final buttonHandler;
  final Color textColorReceived;

  CommonApiErrorWidget(this.text, this.buttonHandler,
      {this.textColorReceived = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          alignment: FractionalOffset.center,
          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textColorReceived,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
        SizedBox(height: 8),
        MaterialButton(
          height: 40,
          color: primaryColor,
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15)),
          onPressed: buttonHandler,
          child: Container(
            padding: EdgeInsets.fromLTRB(
              30,
              0,
              30,
              0,
            ),
            child: Text(
              "Retry",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}
