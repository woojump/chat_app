import 'package:chat_app/config/palette.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class DateSeparator extends StatelessWidget {
  const DateSeparator({
    super.key,
    required this.dateTime,
  });

  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          DateFormat('MMM d, yyyy').format(dateTime),
          style: const TextStyle(
            color: Palette.senderNameColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
