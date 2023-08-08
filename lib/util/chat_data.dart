import 'package:event_app/models/personal_chat_message.dart';
import 'package:flutter/material.dart';

class ChatData {
  static String chatUserEmail = '';
  static int eventId = 0;
  static ValueNotifier valueNotifierReLoadMessages = ValueNotifier(false);
  static List<ChatMessage> chatMessageList = [];
}
