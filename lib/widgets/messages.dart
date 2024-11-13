import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  bool _hasPrevContinuousMessage(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    int index,
  ) {
    if (index == chatDocs.length - 1) {
      return false;
    }
    return chatDocs[index]['userID'] == chatDocs[index + 1]['userID'] &&
        chatDocs[index]['time'].toDate().year ==
            chatDocs[index + 1]['time'].toDate().year &&
        chatDocs[index]['time'].toDate().month ==
            chatDocs[index + 1]['time'].toDate().month &&
        chatDocs[index]['time'].toDate().day ==
            chatDocs[index + 1]['time'].toDate().day &&
        chatDocs[index]['time'].toDate().hour ==
            chatDocs[index + 1]['time'].toDate().hour &&
        chatDocs[index]['time'].toDate().minute ==
            chatDocs[index + 1]['time'].toDate().minute;
  }

  bool _hasNextContinuousMessage(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> chatDocs,
    int index,
  ) {
    if (index == 0) {
      return false;
    }
    return chatDocs[index]['userID'] == chatDocs[index - 1]['userID'] &&
        chatDocs[index]['time'].toDate().year ==
            chatDocs[index - 1]['time'].toDate().year &&
        chatDocs[index]['time'].toDate().month ==
            chatDocs[index - 1]['time'].toDate().month &&
        chatDocs[index]['time'].toDate().day ==
            chatDocs[index - 1]['time'].toDate().day &&
        chatDocs[index]['time'].toDate().hour ==
            chatDocs[index - 1]['time'].toDate().hour &&
        chatDocs[index]['time'].toDate().minute ==
            chatDocs[index - 1]['time'].toDate().minute;
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
            );
          },
        );
      },
    );
  }
}
