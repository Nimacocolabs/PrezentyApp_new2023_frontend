import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:freshchat_sdk/freshchat_user.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FreshchatUser freshchatUser=FreshchatUser(User.userEmail,null);
      freshchatUser.setFirstName(User.userName);
     // freshchatUser.setLastName("Doejv");
      freshchatUser.setEmail(User.userEmail);
      freshchatUser.setPhone("+91",User.userMobile);
      Freshchat.setUser(freshchatUser);
    });
  }

  @override
  void dispose() {
    onLogOut();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:BackButton(),
      ),
      floatingActionButton: FloatingActionButton(
       backgroundColor: Colors.green.shade800,
        child: Icon(Icons.chat_bubble_outline),
        onPressed: (){
          // Freshchat.showFAQ();
          Freshchat.showConversations();
        },
      ),
      body: Center(

      ),
    );
  }

  onLogOut(){
    Freshchat.resetUser();
  }
}
