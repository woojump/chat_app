import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({
    super.key,
    required this.chatRoomID,
    required this.chatRoomName,
    required this.numberOfParticipants,
    this.recentMessageText,
    this.recentMessageTime,
  });

  final String chatRoomID;
  final String chatRoomName;
  final int numberOfParticipants;
  final String? recentMessageText;
  final DateTime? recentMessageTime;

  void _goToChatRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          chatRoomID: chatRoomID,
          chatRoomName: chatRoomName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _goToChatRoom(context);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Column(
          children: [
            Text(chatRoomName),
            Text('$numberOfParticipants'),
            if (recentMessageText != null) Text(recentMessageText!),
            if (recentMessageTime != null) Text('$recentMessageTime'),
          ],
        ),
      ),
    );
  }
}
