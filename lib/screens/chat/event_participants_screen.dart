import 'package:event_app/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_screen.dart';
import 'fragments/blocked_users_fragment.dart';
import 'fragments/participants_fragment.dart';

class EventParticipantsScreen extends StatefulWidget {
  final int eventId;
  final bool isHost;

  const EventParticipantsScreen({Key? key, required this.eventId, required this.isHost}) : super(key: key);

  @override
  _EventParticipantsScreenState createState() =>
      _EventParticipantsScreenState();
}

class _EventParticipantsScreenState extends State<EventParticipantsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                color: primaryColor,
                child: Container(
                  decoration: BoxDecoration(
                      color: primaryColor.shade800,
                      borderRadius: BorderRadius.circular(50)),
                  margin: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            if (_tabIndex == 0) return;
                            setState(() {
                              _tabIndex = 0;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: _tabIndex == 0
                                    ? Colors.white
                                    : primaryColor.shade800,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(child: Text('Users')),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            if (_tabIndex == 1) return;
                            setState(() {
                              _tabIndex = 1;
                            });
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: _tabIndex == 1
                                    ? Colors.white
                                    : primaryColor.shade800,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(child: Text('Blocked Users')),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            SizedBox(
              height: screenHeight - 206,
              child: Container(
                color: Colors.white,
                child: getFragment(_tabIndex),
              ),
              //flex: 1,
            ),
            getBottomButtons()
          ],
        ));
  }

  getFragment(int tabIndex) {
    switch (tabIndex) {
      case 0:
        return ParticipantsScreen(eventId: widget.eventId,isHost: widget.isHost,);
      case 1:
        return BlockedUsersScreen(eventId: widget.eventId,isHost: widget.isHost,);

      default:
        return Center(
          child: Text("Loading error"),
        );
    }
  }

  getBottomButtons() {
    return Container(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: primaryColor.shade400,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.asset('assets/images/ic_exit_chat.png'),
                    ),
                    Text(
                      'Exit Chat',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Material(
              color: secondaryColor.shade700,
              child: InkWell(
                onTap: () {
                  Get.to(() => ChatScreen(
                        eventId: widget.eventId,
                    hideBlock: true,
                      ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Image.asset('assets/images/ic_group_chat.png'),
                    ),
                    Text(
                      'Group Chat',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
