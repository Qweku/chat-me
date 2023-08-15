// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:chat_me/components/button.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:chat_me/provider/contact_provider.dart';
import 'package:chat_me/screens/chat_list.dart';
import 'package:chat_me/screens/contact_list.dart';
import 'package:chat_me/screens/home_screen.dart';
import 'package:chat_me/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  LocalStorage storage = LocalStorage('contacts');
  String? shopName;
  bool initialized = false;

  void bootUp() async {
    //if (await storage.ready) {
    var data = await storage.getItem('user_contact');
    if (data == null) {
      Provider.of<ContactProvider>(context, listen: false).contactList = [];
    } else {
      // log('not empty');
      Provider.of<ContactProvider>(context, listen: false).contactList =
          userModelFromJson(data);
    }
  }

  @override
  void initState() {
    bootUp();
    super.initState();
    //user needs to be created before!
    isEmailVerified = auth.currentUser!.emailVerified;
//  getShopProducts();
    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = auth.currentUser!;
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Color.fromARGB(255, 226, 11, 11),
            content: Text(e.toString(),
                textAlign: TextAlign.center, style: bodyTextWhite),
            duration: const Duration(milliseconds: 1500),
            behavior: SnackBarBehavior.floating,
            shape: const StadiumBorder()),
      );
    }
  }

  Future checkEmailVerified() async {
    //call after email verification
    await auth.currentUser!.reload();
    setState(() {
      isEmailVerified = auth.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return FutureBuilder(
        future: storage.ready,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          if (!initialized) {
            bootUp();

            initialized = true;
          }

          return isEmailVerified
              ? ChatList()
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Container(
                    alignment: const Alignment(0, 0),
                    width: width,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/app_logo.png",
                            height: height * 0.15,
                          ),
                          SizedBox(height: height * 0.01),
                          Text(
                            'Chat Me',
                            style: headTextBlack,
                          ),
                          SizedBox(height: height * 0.05),
                          AnimatedContainer(
                              padding: EdgeInsets.only(bottom: height * 0.03),
                              duration: const Duration(milliseconds: 700),
                              // height: height * 0.5,
                              width: width * 0.9,
                              decoration: BoxDecoration(
                                  // color: primaryColorLight,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: height * 0.03,
                                    right: height * 0.03,
                                    left: height * 0.03),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 15),
                                          child: Text("Email Verification",
                                              style: headTextBlack.copyWith(
                                                  color: primaryColor))),
                                      Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: height * 0.02),
                                          child: Text(
                                              "A verification link has been sent to your email.",
                                              style: bodyTextBlack)),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.04,
                                              bottom: height * 0.01),
                                          child: Button(
                                              width: width,
                                              color: canResendEmail
                                                  ? primaryColor
                                                  : Colors.grey,
                                              // textColor: primaryColorLight,
                                              buttonText: 'Resend Email',
                                              onTap: canResendEmail
                                                  ? sendVerificationEmail
                                                  : () {})),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              top: height * 0.01,
                                              bottom: height * 0.01),
                                          child: Button(
                                            width: width,
                                            buttonShadow: false,
                                            borderColor: primaryColor,
                                            textColor: primaryColor,
                                            buttonText: 'Cancel',
                                            onTap: () async {
                                              await authService.signOut();
                                            },
                                          )),
                                    ]),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }
}
