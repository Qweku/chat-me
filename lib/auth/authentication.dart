import 'package:chat_me/auth/login.dart';
import 'package:chat_me/auth/register.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter/material.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
 DateTime? currentBackPressTime;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop:doubleTapToExit,child: isLogin ? LoginScreen(onTap: toggle,):RegisterScreen(onTap: toggle,));
  }
  Future<bool> doubleTapToExit() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: width*0.45,
            backgroundColor: Color.fromARGB(255, 8, 8, 8),
            content: Text('Repeat action to exit',
                textAlign: TextAlign.center, style: bodyTextWhite),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: const StadiumBorder()),
      );
      return Future.value(false);
    }
    return Future.value(true);
  }
}
