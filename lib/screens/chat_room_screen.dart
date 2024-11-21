import 'package:chat_app/widgets/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({super.key});

  @override
  State<ChatRoomScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatRoomScreen> {
  final _authentication = FirebaseAuth.instance;

  void _createNewChatRoom() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            _authentication.signOut();
          },
          icon: const Icon(
            Icons.logout_outlined,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _createNewChatRoom,
            icon: const Icon(
              Icons.add_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chatrooms')
              // .orderBy(
              //   'time',
              //   descending: true,
              // )
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatRoomDocs = snapshot.data!.docs;
            // if (chatRoomDocs.isEmpty) {
            //   return const Center(
            //     child: Text('Start a new chat'),
            //   );
            // }
            return ListView.builder(
              itemCount: chatRoomDocs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .doc(
                          '/chatrooms/${chatRoomDocs[index].id}/chat/${chatRoomDocs[index]['recentMessageID']}')
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox();
                    }
                    final recentMessageData = snapshot.data!;
                    final user = FirebaseAuth.instance.currentUser;
                    if (chatRoomDocs[index]['participants']
                        .contains(user!.uid)) {
                      return ChatRoom(
                        chatRoomID: chatRoomDocs[index].id,
                        chatRoomName: chatRoomDocs[index]['roomName'],
                        numberOfParticipants:
                            chatRoomDocs[index]['participants'].length,
                        recentMessageText: recentMessageData['text'],
                        recentMessageTime: recentMessageData['time'].toDate(),
                      );
                    }
                    return const SizedBox();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
