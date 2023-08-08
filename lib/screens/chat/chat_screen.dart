
import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/bloc/chat_bloc.dart';
import 'package:event_app/models/personal_chat_message.dart';
import 'package:event_app/screens/login/login_screen.dart';
import 'package:event_app/util/app_helper.dart';
import 'package:event_app/util/chat_data.dart';
import 'package:event_app/util/event_data.dart';
import 'package:event_app/util/shared_prefs.dart';
import 'package:event_app/util/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main_screen.dart';

class ChatScreen extends StatefulWidget {
  //require only eventId for group chat
  //require eventId, opponentEmail for personal chat

  final bool isFromNotification;
  final int eventId;
  final String? opponentEmail;
  final String? displayName;
  final bool isBlocked;
  final bool hideBlock;
  const ChatScreen({Key? key, required this.eventId, this.opponentEmail, this.isFromNotification=false, this.displayName, this.isBlocked=false, this.hideBlock= false}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _itemsScrollController;
  late VoidCallback refreshUIFn;
  ChatBloc _bloc=ChatBloc();
  bool isBlocked = false;

  @override
  void initState() {
    super.initState();
    isBlocked = widget.isBlocked;

    ChatData.chatMessageList=[];

    _itemsScrollController = ScrollController();
    _itemsScrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('User.apiToken:${User.apiToken}.');
      if(widget.isFromNotification && User.apiToken.trim().isEmpty){
        await SharedPrefs.init();
      }
      await EventData.initPath();

      refreshUIFn = () {
        if(mounted){
          // setState(() {});
          _bloc.getMessages(widget.opponentEmail);
        }
      };
      ChatData.eventId=widget.eventId;
      ChatData.valueNotifierReLoadMessages.addListener(refreshUIFn);


      _bloc.getList(widget.opponentEmail);

    });

  }

  void _scrollListener() {
    if (_itemsScrollController.offset >=
        _itemsScrollController.position.maxScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the bottom");
      if (_bloc.hasNextPage) {
        _bloc.getList(widget.opponentEmail);
      }
    }
    if (_itemsScrollController.offset <=
        _itemsScrollController.position.minScrollExtent &&
        !_itemsScrollController.position.outOfRange) {
      print("reach the top");
    }
  }

  @override
  void dispose() {
    ChatData.eventId=0;
    ChatData.valueNotifierReLoadMessages.removeListener(refreshUIFn);
    _itemsScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        _onBackPressed();
        return false;
      },
      child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100,100),
        child: Container(
          color: primaryColor,
          padding: EdgeInsets.fromLTRB(8, MediaQuery.of(context).padding.top+8, 12, 8),
          child: Row(
            children: [
              IconButton(
                onPressed: _onBackPressed,
                icon: Icon(Icons.arrow_back_rounded,color: Colors.white,),
              ),
              SizedBox(width: 4,),
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white,
                child: SizedBox(
                  width: 60,
                  height:60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: 'https://prezenty.in/prezenty/api/web/v1/user/user-image?user_id=&email=${widget.opponentEmail}',
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/images/ic_person_avatar.png'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12,),
              Expanded(child: Text(widget.displayName??widget.opponentEmail??'Group Chat',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.white),)),

              Visibility(
                visible: (!widget.hideBlock),
                child: PopupMenuButton<int>(
                  icon: Icon(
                    Icons.more_vert,color:Colors.white,
                  ),
                  onSelected: (value) async {
                    bool b;
                    if(isBlocked){
                      b = await _bloc.unBlock(widget.eventId, ChatData.chatUserEmail, widget.opponentEmail!);
                      isBlocked = false;
                    }else{
                      b = await _bloc.block(widget.eventId, ChatData.chatUserEmail, widget.opponentEmail!);
                      isBlocked = true;
                    }

                    if(b){
                      setState(() {});
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                        value: 1,
                        child: Text(isBlocked?'Unblock':'Block')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            StreamBuilder<bool>(
                stream: _bloc.isPreviousLoadingStream,
                builder: (context, snapshot) {
                  if (!(snapshot.data??false)) {
                    return Container();
                  }
                  return LinearProgressIndicator(color: secondaryColor.shade400,);
                }),

            Expanded(
              child:  StreamBuilder<dynamic>(
                  stream: _bloc.itemsStream,
                  builder: (context, snapshot) {
                    return _buildList();
                  }),
            ),

            StreamBuilder<bool>(
                stream: _bloc.isSendingLoadingStream,
                builder: (context, snapshot) {
                  if(isBlocked)
                    return Container(
                      width: double.maxFinite,
                      padding:EdgeInsets.all(14),
                      decoration: BoxDecoration(
                          color: secondaryColor.shade50,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
                      ),
                      child: Text('This chat is Blocked. Unblock to send/receive messages',textAlign: TextAlign.center,style: TextStyle(color: Colors.grey),),
                    );

                  bool isSending=snapshot.data??false;
                  return Container(
                    padding:EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: secondaryColor.shade50,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12))
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            enabled: !isSending,
                            controller: _bloc.textFieldControl.controller,
                            focusNode: _bloc.textFieldControl.focusNode,
                            minLines: 1,
                            maxLines: 3,
                            decoration: InputDecoration(
                                hintText: 'Write something',
                                hintStyle: TextStyle(
                                  // color: blueGrey300,
                                )
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        InkWell(
                          onTap: isSending?null:_validate,
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius: const BorderRadius.all(Radius.circular(8)),
                              ),
                              child:
                              SizedBox(
                                height: 34,
                                width: 34,
                                child: isSending
                                    ? CircularProgressIndicator()
                                    : Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                ),
                              )),
                        )
                      ],
                    ),
                  );
                }),

          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if(ChatData.chatMessageList.isEmpty) return Center(child: Text('No Messages'));
    return ListView.builder(
      controller: _itemsScrollController,
      shrinkWrap: true,
      reverse: true,
      itemCount: ChatData.chatMessageList.length,
      itemBuilder: (context,index){
        ChatMessage item=ChatData.chatMessageList[index];
        return _messageHolder(item.senderEmail, item.message!, item.displayTime??'');
      },
    );
  }

  Widget _messageHolder(String? senderEmail, String msg, String date){
    bool isRight = (senderEmail==ChatData.chatUserEmail);
    Widget child = Container(
      constraints: BoxConstraints(
        maxWidth: screenWidth*.7,
        minWidth: 100,
      ),
      margin: EdgeInsets.all(8),
      padding:EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRight?Colors.cyan.shade100:Colors.blue.shade100,
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.opponentEmail==null
              ?Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(isRight?'You':'$senderEmail',textAlign: TextAlign.start,style: TextStyle(fontSize: 12,color: primaryColor,fontWeight: FontWeight.bold),),
          )
              :Container(),

          Text('$msg',textAlign: TextAlign.start,style: TextStyle(fontSize: 16,
          ),),
          SizedBox(height: 6,),
          Text('$date',textAlign: TextAlign.start,
            style: TextStyle(fontSize: 12,color: Colors.black38),
          ),
        ],
      ),
    );


    if(isRight){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 0,
            ),
          ),
          Flexible(
              fit: FlexFit.loose,
              flex: 5,
              child: child
          ),
        ],
      );
    }
    else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Flexible(
            fit: FlexFit.loose,
            flex: 5,
            child: child,
          ),
          Flexible(
            flex: 1,
            child: SizedBox(
              width: 0,
            ),
          ),
        ],
      );
    }
  }

  _onBackPressed() {
    if(widget.isFromNotification){
      if(User.apiToken.isEmpty){
        Get.offAll(()=>LoginScreen(isFromWoohoo: false,));
      }else{
        Get.offAll(()=>MainScreen());
      }
    }else {
      Get.back(result: (widget.isBlocked != isBlocked));
    }
  }

  _validate() {
    String msg = _bloc.textFieldControl.controller.text.trim();
    if(msg.isEmpty){
      _bloc.textFieldControl.focusNode.requestFocus();
    }else {
      _bloc.sendMessage(msg, widget.opponentEmail);
    }
  }

}