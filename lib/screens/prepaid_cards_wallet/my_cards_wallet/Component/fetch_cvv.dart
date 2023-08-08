import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_browser/web_browser.dart';

class FetchCVVScreen extends StatefulWidget {
  final String url;

  const FetchCVVScreen({Key? key, required this.url}) : super(key: key);

  @override
  State<FetchCVVScreen> createState() => _FetchCVVScreenState();
}

class _FetchCVVScreenState extends State<FetchCVVScreen> {
  late String url;
  @override
  void initState() {
    super.initState();

    url = Uri.encodeFull(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Card CVV'),
      //   centerTitle: true,
      // ),
      appBar: CommonAppBarWidget(
        title: 'Card CVV',
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      body:  SafeArea(
        child: WebBrowser(
          initialUrl: url,
          javascriptEnabled: true,
          interactionSettings: WebBrowserInteractionSettings(
              topBar: null, bottomBar: null, gestureNavigationEnabled: false),
        ),
      ),
    );
  }
}
