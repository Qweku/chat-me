// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter/material.dart';

class Toast {
  BuildContext context;
  String labelText;
  Color? color;
  int duration;
  Toast({
    required this.context,
    required this.labelText,
    this.color = Colors.green,
    this.duration = 3,
  }) {
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          width: width * 0.6,
          backgroundColor: color,
          content: Text(labelText,
              textAlign: TextAlign.center,
              style: bodyTextWhite),
          duration: Duration(seconds: duration),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder()),
    );
  }

  Toast.error({
    required this.labelText,
    required this.context,
    this.duration = 5,
  }) {
   
   
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          width: width * 0.6,
          backgroundColor: Color.fromARGB(255, 230, 22, 7),
          content: Text(labelText,
              textAlign: TextAlign.center,
              style: bodyTextWhite
                 ),
          duration: Duration(seconds: duration),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder()),
    );
  }
  Toast.success({
    required this.labelText,
    required this.context,
    this.duration = 5,
  }) {
    
   
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          width: width * 0.6,
          backgroundColor:Color.fromARGB(255, 33, 156, 37),
          content: Text(labelText,
              textAlign: TextAlign.center,
              style: bodyTextWhite),
          duration: Duration(seconds: duration),
          behavior: SnackBarBehavior.floating,
          shape: StadiumBorder()),
    );
  }
}