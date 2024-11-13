import 'package:chat_app/config/palette.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.userName,
    required this.message,
    required this.isMe,
    required this.dateTime,
    required this.hasPrevContinuousMessage,
    required this.hasNextContinuousMessage,
  });

  final String userName;
  final String message;
  final bool isMe;
  final DateTime dateTime;
  final bool hasPrevContinuousMessage;
  final bool hasNextContinuousMessage;

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isMe && !hasPrevContinuousMessage)
              Padding(
                padding: const EdgeInsets.only(
                  left: 28.0,
                  top: 6.0,
                ),
                child: Text(
                  userName,
                  style: const TextStyle(
                    color: Palette.senderNameColor,
                    fontSize: 12.0,
                  ),
                ),
              ),
            BubbleSpecialThree(
              isSender: isMe ? true : false,
              color: isMe
                  ? Palette.myChatBubbleColor
                  : Palette.otherChatBubbleColor,
              tail: hasNextContinuousMessage ? false : true,
              text: message,
              textStyle: TextStyle(
                fontSize: 16.0,
                color: isMe ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
        if (!hasNextContinuousMessage)
          Text(
            DateFormat('HH:mm').format(dateTime),
            style: const TextStyle(
              color: Palette.senderNameColor,
              fontSize: 12.0,
            ),
          ),
      ],
    );
  }
}
