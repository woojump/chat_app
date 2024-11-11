import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessageField extends StatefulWidget {
  const NewMessageField({super.key});

  @override
  State<NewMessageField> createState() => _NewMessageFieldState();
}

class _NewMessageFieldState extends State<NewMessageField> {
  String _userEnterMessage = '';
  final _controller = TextEditingController();
  void _sendMessage() {
    FirebaseFirestore.instance.collection('chat').add({
      'text': _userEnterMessage,
      'time': Timestamp.now(),
    });
    _controller.clear();
    setState(() {
      _userEnterMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Enter a message',
            ),
            onChanged: (value) {
              setState(() {
                _userEnterMessage = value;
              });
            },
          ),
        ),
        IconButton(
          onPressed: _userEnterMessage.isEmpty ? null : _sendMessage,
          icon: const Icon(
            Icons.send,
          ),
          color: Colors.green,
        ),
      ],
    );
  }
}
