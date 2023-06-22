import 'package:chat_me/auth/authentication.dart';
import 'package:chat_me/auth/verify_email.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);
  static const String routeName = '/';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<UserModel?>(
        stream: authService.user, //FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserModel? user = snapshot.data;
            if (user == null) {
              return const Authentication();
            }

            return const VerifyEmailScreen();
          } else {
            return CircularProgressIndicator(
              color: primaryColor,
            );
          }
        });
  }

  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Responsive.isMobile()
  //           ? const Authentication()
  //           : const TabletAuth());
  // }
}
