import 'package:flutter/material.dart';

class CommonApiResultsEmptyWidget extends StatelessWidget {
  final String msg;
  final Color textColorReceived;

  CommonApiResultsEmptyWidget(this.msg,
      {this.textColorReceived = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: FractionalOffset.center,
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Image(
            image: AssetImage('assets/images/no_data.png'),
            height: MediaQuery.of(context).size.height * .20,
            width: MediaQuery.of(context).size.width * .40,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(
              10,
              10,
              10,
              10,
            ),
            child: Text(
              "$msg",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  decoration: TextDecoration.none,
                  color: textColorReceived,
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
