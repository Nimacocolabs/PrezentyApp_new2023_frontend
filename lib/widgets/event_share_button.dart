import 'dart:developer';

import 'package:event_app/services/dynamic_link_service.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class EventShareButton extends StatelessWidget {
  final int eventId;
  final String eventTitle;
  final String? eventImageUrl;
  final VoidCallback? onTap;

  const EventShareButton(
      {Key? key, required this.eventId, this.onTap, required this.eventTitle, this.eventImageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: secondaryColor,
      child: InkWell(
        onTap: onTap ??
            () async {
              Uri url = await DynamicLinkService().createDynamicLink(eventId,eventImageUrl,eventTitle);

              String text =
                  '${eventTitle.isEmpty ? '' : 'You are invited to this $eventTitle\n\n'}${url.toString()}';
              log(text);
              Share.share('$text');
            },
        child: Container(
          padding: EdgeInsets.all(18),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/ic_share.png',
                width: 20,
                height: 20,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                onTap==null?'Share':'Save And Share',
                style: TextStyle(color: Colors.white, fontSize: 16),
              )
            ],
          ),
        ),
      ),
    );
  }
}
