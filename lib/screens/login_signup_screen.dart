import 'package:chat_app/config/palette.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({super.key});

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  final _authentication = FirebaseAuth.instance;

  bool isSignupScreen = false;
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userEmail = '';
  String userPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                height: 300.0,
                padding: const EdgeInsets.only(bottom: 50.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpeg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'MY CHAT',
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontSize: 25.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              top: isSignupScreen ? 390.0 : 330.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    if (isSignupScreen) {
                      _formKey.currentState!.save();
                      if (userName.length < 4) {
                        Fluttertoast.showToast(
                          msg: 'Username must be at least 4 characters long.',
                          gravity: ToastGravity.CENTER,
                        );
                      } else if (!userEmail.contains('@')) {
                        Fluttertoast.showToast(
                          msg: 'Please enter a valid email address.',
                          gravity: ToastGravity.CENTER,
                        );
                      } else if (userPassword.length < 6) {
                        Fluttertoast.showToast(
                          msg: 'Password must be at least 6 characters long.',
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        try {
                          final newUser = await _authentication
                              .createUserWithEmailAndPassword(
                            email: userEmail,
                            password: userPassword,
                          );

                          await FirebaseFirestore.instance
                              .collection('user')
                              .doc(newUser.user!.uid)
                              .set({
                            'Username': userName,
                            'Email': userEmail,
                          });
                        } catch (e) {
                          debugPrint('$e');
                        }
                      }
                    }
                    if (!isSignupScreen) {
                      _formKey.currentState!.save();
                      if (userEmail.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter your email address.',
                          gravity: ToastGravity.CENTER,
                        );
                      } else if (userPassword.isEmpty) {
                        Fluttertoast.showToast(
                          msg: 'Please enter your password.',
                          gravity: ToastGravity.CENTER,
                        );
                      } else {
                        try {
                          await _authentication.signInWithEmailAndPassword(
                            email: userEmail,
                            password: userPassword,
                          );
                        } catch (e) {
                          debugPrint('$e');
                          Fluttertoast.showToast(
                            msg: 'Invalid email address or password.',
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      }
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 45.0),
                    height: 100.0,
                    width: MediaQuery.of(context).size.width - 100,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Colors.green,
                          Colors.lightGreen,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        isSignupScreen ? 'SIGN UP' : 'LOGIN',
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              top: 180.0,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn,
                padding: const EdgeInsets.all(20.0),
                height: isSignupScreen ? 260.0 : 200.0,
                width: MediaQuery.of(context).size.width - 40,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15.0,
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = false;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: !isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3.0),
                                  height: 2.0,
                                  width: 55.0,
                                  color: !isSignupScreen
                                      ? Colors.lightGreen
                                      : Colors.lightGreen.withOpacity(0.0),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignupScreen = true;
                              });
                            },
                            child: Column(
                              children: [
                                Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: isSignupScreen
                                        ? Palette.activeColor
                                        : Palette.textColor1,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3.0),
                                  height: 2.0,
                                  width: 55.0,
                                  color: isSignupScreen
                                      ? Colors.lightGreen
                                      : Colors.lightGreen.withOpacity(0.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (!isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(1),
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  key: const ValueKey(2),
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (isSignupScreen)
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  key: const ValueKey(3),
                                  onSaved: (value) {
                                    userName = value!;
                                  },
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.account_circle,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: 'Username',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  key: const ValueKey(4),
                                  onSaved: (value) {
                                    userEmail = value!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: 'Email',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                TextFormField(
                                  key: const ValueKey(5),
                                  onSaved: (value) {
                                    userPassword = value!;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.lock,
                                      color: Palette.iconColor,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Palette.textColor1,
                                      ),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Palette.textColor1,
                                    ),
                                    contentPadding: const EdgeInsets.all(10.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 550.0,
              left: 0.0,
              right: 0.0,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 1.0,
                        width: MediaQuery.of(context).size.width - 40,
                        color: Palette.textColor1,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        color: Palette.backgroundColor,
                        child: Text(
                          isSignupScreen ? 'or sign up with' : 'or login with',
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Palette.textColor1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Palette.googleColor,
                    ),
                    child: Image.asset(
                      'assets/icon_google.png',
                      color: Colors.white,
                      height: 30.0,
                      width: 30.0,
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
