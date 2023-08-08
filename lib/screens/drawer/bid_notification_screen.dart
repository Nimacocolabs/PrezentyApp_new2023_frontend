import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:event_app/widgets/title_with_see_all.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class BidNotificationScreen extends StatefulWidget {
  const BidNotificationScreen({Key? key, required bool isFromNotification,  this.title,  this.imageUrl, this.url,  }) : super(key: key);
final title;
final imageUrl;
final url;
  @override
  _BidNotificationScreenState createState() => _BidNotificationScreenState();
}

class _BidNotificationScreenState extends State<BidNotificationScreen> {

  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    print("url ${widget.url}");
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
          appBar: CommonAppBarWidget(
            onPressedFunction: () {
              Get.back();
            },
            image: User.userImageUrl,
            title: "Notifications",
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: screenHeight * 0.02,),
                  Text("${widget.title} !",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22,
                      fontFamily: "serif"
                  ),),
                  Container(
                    color: Colors.grey[200],
                    margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedNetworkImage(
                        fit: BoxFit.fitWidth,
                        imageUrl: "${widget.imageUrl}",
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: screenHeight * 0.6,
                            margin: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage('assets/images/bid.jpg'),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: (){
                         // launchUrl(widget.url);
                         launchUrl(Uri.parse(widget.url));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Join Now'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
