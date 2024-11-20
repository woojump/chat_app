import 'package:chat_app/config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessageField extends StatefulWidget {
  const NewMessageField({
    super.key,
    required this.chatRoomID,
  });

  final String chatRoomID;

  @override
  State<NewMessageField> createState() => _NewMessageFieldState();
}

class _NewMessageFieldState extends State<NewMessageField> {
  String _userEnterMessage = '';
  late final TextEditingController _controller;

  void _sendMessage() async {
    final user = FirebaseAuth.instance.currentUser;
    final firestore = FirebaseFirestore.instance;
    final userData = await firestore.collection('user').doc(user!.uid).get();
    await firestore.collection('/chatrooms/${widget.chatRoomID}/chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
      'userID': user.uid,
      'userName': userData['Username'],
    });
    _controller.clear();
    setState(() {
      _userEnterMessage = '';
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      width: MediaQuery.sizeOf(context).width - 40.0,
      // height: 40.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: Palette.textColor1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 7,
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.none,
                  ),
                ),
                hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: Palette.textColor1,
                ),
                hintText: 'Enter a message',
                contentPadding: EdgeInsets.fromLTRB(14.0, 6.0, 0.0, 6.0),
              ),
              onChanged: (value) {
                setState(() {
                  _userEnterMessage = value;
                });
              },
            ),
          ),
          if (_userEnterMessage.isNotEmpty)
            GestureDetector(
              onTap: _sendMessage,
              child: Container(
                margin: const EdgeInsets.all(4.0),
                height: 32.0,
                width: 32.0,
                decoration: BoxDecoration(
                  color: Palette.myChatBubbleColor,
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const Icon(
                  Icons.arrow_upward_rounded,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
