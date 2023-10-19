import 'package:chat_me/components/button.dart';
import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/services/firebase_auth.dart';
import 'package:chat_me/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ForgottenPassword extends StatefulWidget {
  const ForgottenPassword({
    super.key,
  });

  @override
  State<ForgottenPassword> createState() => _ForgottenPasswordState();
}

class _ForgottenPasswordState extends State<ForgottenPassword> {
  TextEditingController emailController = TextEditingController();

  void loginError(
    Exception e,
  ) {
    showDialog<void>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Icon(Icons.cancel,
                color: Color.fromARGB(255, 216, 30, 17), size: 50),

            // Text(
            //   "LOGIN ERROR",textAlign: TextAlign.center,
            //   style: TextStyle(fontWeight: FontWeight.bold,color:Color.fromARGB(255, 233, 22, 7), fontSize: 18),
            // ),
            content: Text("${(e as dynamic).message}"),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.of(context).pop()),
                  child: const Text("OK"))
            ],
          );
        });
  }

  void reset() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    if (emailController.text.isEmpty) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'Email required');
      return;
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )));

    await authService
        .forgottenPassword(
      emailController.text,
    )
        .then((user) {
      navigatorKey.currentState!.pop((route) => route);
    }).catchError((e) {
      navigatorKey.currentState!.pop((route) => route);
      loginError(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 8, 0, 92),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: height * 0.15),
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Image.asset(
                    "assets/images/app_logo.png",
                    height: height * 0.15,
                  )),
              const SizedBox(
                height: 30,
              ),
              Text(
                'Reset Password',
                style: headTextWhite.copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 50,
              ),
              CustomTextField(
                prefixIcon:
                    const Icon(Icons.email, color: Colors.grey, size: 18),
                style: bodyTextBlack,
                color: lightGreyColor,
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 50,
              ),
              Button(
                color: secondaryColor,
                width: width,
                buttonText: 'Reset',
                onTap: reset,
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                borderColor: secondaryColor,
                width: width,
                buttonShadow: false,
                buttonText: 'Cancel',
                textColor: secondaryColor,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      )),
    );
  }
}
