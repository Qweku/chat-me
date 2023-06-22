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

class LoginScreen extends StatefulWidget {
  final Function()? onTap;
  const LoginScreen({super.key, this.onTap});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isChecked = false;
  bool obscure = true;
  IconData visibility = Icons.visibility_off;

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

  void login() async {
    final authService = Provider.of<AuthService>(context,listen: false);
     if (emailController.text.isEmpty) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'Email required');
      return;
    }
    if (passwordController.text.isEmpty) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'Password required');
      return;
    }
    if (passwordController.text.length < 4) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'Password length too short');
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
        .signInWithEmailAndPassword(
            emailController.text, passwordController.text)
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
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height:height*0.15),
              Image.asset("assets/images/app_logo.png",height: height*0.15,),
              const SizedBox(
                height: 50,
              ),
              Text(
                'Login to Your Account',
                style: headTextBlack.copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                prefixIcon: const Icon(Icons.email, color: Colors.grey, size: 18),
                style: bodyTextBlack,
                color: lightGreyColor,
                controller: emailController,
                hintText: 'Email',
              ),
              const SizedBox(
                height: 15,
              ),
              CustomTextField(
                obscure: obscure,
                prefixIcon: const Icon(Icons.lock, color: Colors.grey, size: 18),
                style: bodyTextBlack,
                color: lightGreyColor,
                controller: passwordController,
                hintText: 'Password',
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      obscure = !obscure;
                      if (!obscure) {
                        visibility = Icons.visibility;
                      } else {
                        visibility = Icons.visibility_off;
                      }
                    });
                  },
                  child: Container(
                    // alignment: Alignment(1.0,50.0),
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(visibility, size: 18, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                
                  
                  TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot the password?',
                        style: bodyTextBlack.copyWith(color: secondaryColor),
                      )),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Button(
                color: primaryColor,
                width: width,
                buttonText: 'Login',
                onTap: login,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: bodyTextBlack.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Sign Up',
                      style: bodyTextBlack.copyWith(color: secondaryColor),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
