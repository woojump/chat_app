import 'package:chat_app/widgets/messages.dart';
import 'package:chat_app/widgets/new_message_field.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chatRoomID,
  });

  final String chatRoomID;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Messages(
                  chatRoomID: widget.chatRoomID,
                ),
              ),
              NewMessageField(
                chatRoomID: widget.chatRoomID,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
