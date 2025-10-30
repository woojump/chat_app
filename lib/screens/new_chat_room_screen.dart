import 'package:chat_app/config/palette.dart';
import 'package:chat_app/models/user_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewChatRoomScreen extends StatefulWidget {
  const NewChatRoomScreen({super.key});

  @override
  State<NewChatRoomScreen> createState() => _NewChatRoomScreenState();
}

class _NewChatRoomScreenState extends State<NewChatRoomScreen> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late final Future<List<UserModel>> usersFuture;
  late List<UserModel> users;
  String currentUserName = '';
  int numberOfSelectedUsers = 0;

  Future<List<UserModel>> _fetchUsersFromFirestore() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('user').get();
    final userDocs = querySnapshot.docs;
    final List<UserModel> usersFuture = [];
    for (var userDoc in userDocs) {
      if (userDoc.id != currentUser.uid) {
        usersFuture.add(UserModel(
          userID: userDoc.id,
          userName: userDoc['Username'],
        ));
      } else {
        currentUserName = userDoc['Username'];
      }
    }
    return usersFuture;
  }

  void _createNewChatRoom() async {
    final List<String> participants = [currentUser.uid];
    String roomName = currentUserName;

    for (var user in users) {
      if (user.isSelected) {
        participants.add(user.userID);
        roomName += ', ${user.userName}';
      }
    }
    // roomName = roomName.replaceFirst(', ', '');

    final firestore = FirebaseFirestore.instance;
    final newChatRoomDoc = await firestore.collection('chatrooms').add({
      'roomName': roomName,
      'participants': participants,
      'recentMessageID': null,
    });

    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ChatScreen(chatRoomID: newChatRoomDoc.id, chatRoomName: roomName),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    usersFuture = _fetchUsersFromFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Friends'),
        actions: [
          IconButton(
            onPressed: numberOfSelectedUsers == 0 ? null : _createNewChatRoom,
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: FutureBuilder(
        future: usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  setState(() {
                    users[index].isSelected = !users[index].isSelected;
                    if (users[index].isSelected) {
                      numberOfSelectedUsers++;
                    } else {
                      numberOfSelectedUsers--;
                    }
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(users[index].userName),
                      Container(
                        decoration: BoxDecoration(
                          color: users[index].isSelected
                              ? Palette.myChatBubbleColor
                              : Colors.transparent,
                          border: Border.all(
                            color: users[index].isSelected
                                ? Palette.myChatBubbleColor
                                : Palette.senderNameColor,
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Icon(
                          Icons.check,
                          color: users[index].isSelected
                              ? Colors.white
                              : Colors.transparent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
