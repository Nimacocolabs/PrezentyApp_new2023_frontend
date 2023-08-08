import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoVideoScreen extends StatefulWidget {
  final String videoId;

  const InfoVideoScreen({Key? key, required this.videoId}) : super(key: key);

  @override
  _InfoVideoScreenState createState() => _InfoVideoScreenState();
}

class _InfoVideoScreenState extends State<InfoVideoScreen> {
//todo check video
  List<Map<String, dynamic>> _videoList = [
    {
      'id': 'create_event',
      'title': 'How to create an event',
      'yt_video_id': 'YTNa7bxyzJM',
    },
    {
      'id': 'edit_event',
      'title': 'How to edit an event',
      'yt_video_id': 'PeCmj8VOqQk',
    },
  ];

  Map<String, dynamic> _currentVideo = {};

  @override
  void initState() {
    super.initState();

    _videoList.any((element) {
      if (element['id'] == widget.videoId) {
        _currentVideo = element;
        return true;
      }
      return false;
    });

    if (_currentVideo.isEmpty) {
      toastMessage('Video not found');
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar:CommonAppBarWidget(
              onPressedFunction: (){
                Get.back();
              },
              image: User.userImageUrl,
            ),
      body: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_currentVideo['title']}',
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(
                height: 12,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GestureDetector(
                  onTap: () async {
                    String url =
                        'https://youtu.be/${_currentVideo['yt_video_id']}';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      toastMessage('Could not open video');
                    }
                  },
                  child: Container(
                    height: 200,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl:
                              'https://img.youtube.com/vi/${_currentVideo['yt_video_id']}/0.jpg',
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Center(
                            child: SizedBox(
                                height: 42,
                                width: 42,
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            margin: EdgeInsets.all(5),
                            child: Image(
                              image: AssetImage('assets/images/no_image.png'),
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                            child: Icon(Icons.play_arrow),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
