import 'package:chat_app/config/palette.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart' show DateFormat;

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

  bool isToday(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year && dt1.month == dt2.month && dt1.day == dt2.day;
  }

  bool isYesterday(DateTime dt1, DateTime dt2) {
    DateTime firstDate = DateTime(dt1.year, dt1.month, dt1.day);
    DateTime secondDate = DateTime(dt2.year, dt2.month, dt2.day);

    Duration difference = firstDate.difference(secondDate);

    return difference.inDays == -1;
  }

  String getRecentMessageTimeDetail() {
    final now = DateTime.now();

    if (isToday(recentMessageTime!, now)) {
      return DateFormat('HH:mm').format(recentMessageTime!);
    }

    if (isYesterday(recentMessageTime!, now)) {
      return 'Yesterday';
    }

    return DateFormat('M/d/yy').format(recentMessageTime!);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double availableWidth = screenWidth - 48.0 - 10.0 - 40.0;

    return GestureDetector(
      onTap: () {
        _goToChatRoom(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20.0,
        ),
        decoration: const BoxDecoration(),
        child: Row(
          children: [
            const CircleAvatar(
              minRadius: 24.0,
              backgroundImage: AssetImage('assets/default_profile_picture.jpg'),
            ),
            const SizedBox(
              width: 10.0,
            ),
            SizedBox(
              width: availableWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            chatRoomName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 6.0,
                          ),
                          Text(
                            '$numberOfParticipants',
                            style: const TextStyle(
                              color: Palette.senderNameColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      if (recentMessageTime != null)
                        Text(
                          getRecentMessageTimeDetail(),
                          style: const TextStyle(
                            color: Palette.senderNameColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2.0),
                  SizedBox(
                    height: 40.0,
                    child: Text(
                      recentMessageText ?? '',
                      style: const TextStyle(
                        color: Palette.senderNameColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
