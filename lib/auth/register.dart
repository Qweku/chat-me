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

class RegisterScreen extends StatefulWidget {
  final Function()? onTap;
  const RegisterScreen({super.key, this.onTap});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isChecked = false;
  bool isMatched = false;
  bool obscure = true;
  IconData visibility = Icons.visibility_off;

  void register() async {
    final authService = Provider.of<AuthService>(context,listen: false);
    if (userController.text.isEmpty) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'User Name required');
      return;
    } if (emailController.text.isEmpty) {
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
    if (confirmPasswordController.text.isEmpty) {
      Toast(
          context: context,
          color: const Color.fromARGB(255, 230, 22, 7),
          labelText: 'Please confirm password');
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
                child: CircularProgressIndicator(
              color: Colors.white,
            )));
    await authService.createUserWithEmailAndPassword(
        userController.text, emailController.text, passwordController.text);

    navigatorKey.currentState!.pop((route) => route);
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
                'Create a new account',
                style: headTextBlack.copyWith(fontSize: 18),
              ),
              const SizedBox(
                height: 30,
              ),
              CustomTextField(
                prefixIcon:
                    const Icon(Icons.person, color: Colors.grey, size: 18),
                style: bodyTextBlack,
                color: lightGreyColor,
                controller: userController,
                hintText: 'Username',
              ),
              const SizedBox(
                height: 15,
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
              CustomTextField(
                  obscure: obscure,
                  prefixIcon:
                      const Icon(Icons.lock, color: Colors.grey, size: 18),
                  style: bodyTextBlack,
                  color: lightGreyColor,
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  onChanged: (val) {
                    if (val == passwordController.text) {
                      setState(() {
                        isMatched = !isMatched;
                      });
                    }
                  },
                  suffixIcon: Icon(
                    isMatched ? Icons.check_circle : Icons.cancel,
                    color: isMatched
                        ? Colors.green
                        : const Color.fromARGB(255, 238, 21, 6),
                    size: 18,
                  )),
              const SizedBox(
                height: 50,
              ),
              Button(
                color: primaryColor,
                width: width,
                buttonText: 'Sign Up',
                onTap: register,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: bodyTextBlack.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(
                    width: 7,
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Login',
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
