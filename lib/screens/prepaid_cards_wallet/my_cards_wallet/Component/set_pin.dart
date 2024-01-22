import 'package:event_app/util/user.dart';
import 'package:event_app/widgets/common_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web_browser/web_browser.dart';

class SetCardPin extends StatelessWidget {
  final String url;

  const SetCardPin({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page-->${url}");
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Set PIN'),
      //   centerTitle: true,
      // ),
      appBar: CommonAppBarWidget(
        title: 'Set PIN',
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      body: SafeArea(
        child: WebBrowser(
          initialUrl: url,
          javascriptEnabled: true,
          interactionSettings: WebBrowserInteractionSettings(
              topBar: null, bottomBar: null, gestureNavigationEnabled: false,

              ),
        ),
      ),
    );
  }
}
class ViewcardPin extends StatelessWidget {
  final String url;

  const ViewcardPin({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("page-->${url}");
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Set PIN'),
      //   centerTitle: true,
      // ),
      appBar: CommonAppBarWidget(
        title: 'Card',
        onPressedFunction: () {
          Get.back();
        },
        image: User.userImageUrl,
      ),
      body: SafeArea(
        child: WebBrowser(
          initialUrl: url,
          javascriptEnabled: true,
          interactionSettings: WebBrowserInteractionSettings(
            topBar: null, bottomBar: null, gestureNavigationEnabled: false,

          ),
        ),
      ),
    );
  }
}
