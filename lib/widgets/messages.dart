import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  bool _isSameTime(DateTime dt1, DateTime dt2) {
    return dt1.year == dt2.year &&
        dt1.month == dt2.month &&
        dt1.day == dt2.day &&
        dt1.hour == dt2.hour &&
        dt1.minute == dt2.minute;
  }

  bool _hasPrevContinuousMessage(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    int index,
  ) {
    if (index == chatDocs.length - 1) {
      return false;
    }

    final currentChatDoc = chatDocs[index];
    final prevChatDoc = chatDocs[index + 1];

    final bool isSameUser = currentChatDoc['userID'] == prevChatDoc['userID'];
    final bool isSameTime = _isSameTime(
        currentChatDoc['time'].toDate(), prevChatDoc['time'].toDate());

    return isSameUser && isSameTime;
  }

  bool _hasNextContinuousMessage(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    int index,
  ) {
    if (index == 0) {
      return false;
    }
    final currentChatDoc = chatDocs[index];
    final nextChatDoc = chatDocs[index - 1];

    final bool isSameUser = currentChatDoc['userID'] == nextChatDoc['userID'];
    final bool isSameTime = _isSameTime(
        currentChatDoc['time'].toDate(), nextChatDoc['time'].toDate());

    return isSameUser && isSameTime;
  }

  bool _isFirstMessageOfTheDay(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    int index,
  ) {
    if (index == chatDocs.length - 1) {
      return true;
    }
    final currentChatDocTime = chatDocs[index]['time'].toDate();
    final prevChatDocTime = chatDocs[index + 1]['time'].toDate();

    return !(currentChatDocTime.year == prevChatDocTime.year &&
        currentChatDocTime.month == prevChatDocTime.month &&
        currentChatDocTime.day == prevChatDocTime.day);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy(
            'time',
            descending: true,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (context, index) {
            final user = FirebaseAuth.instance.currentUser;
            return ChatBubble(
              userName: chatDocs[index]['userName'],
              message: chatDocs[index]['text'],
              isMe: chatDocs[index]['userID'] == user!.uid,
              dateTime: chatDocs[index]['time'].toDate(),
              hasPrevContinuousMessage:
                  _hasPrevContinuousMessage(chatDocs, index),
              hasNextContinuousMessage:
                  _hasNextContinuousMessage(chatDocs, index),
              isFirstMessageOfTheDay: _isFirstMessageOfTheDay(chatDocs, index),
            );
          },
        );
      },
    );
  }
}
