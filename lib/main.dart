import 'package:chat_app/screens/login_signup_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Chat app',
      home: LoginSignupScreen(),
    );
  }
}
