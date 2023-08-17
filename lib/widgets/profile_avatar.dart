import 'dart:convert';

import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.1,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            child: Icon(Icons.person, color: Colors.grey),
            radius: 35,
          ),
          Positioned(
              bottom: height * 0.03,
              right: 2,
              child: Icon(
                Icons.circle,
                size: 18,
                color: Color.fromARGB(255, 9, 182, 15),
              ))
        ],
      ),
    );
  }
}

class ProfileAvatar2 extends StatelessWidget {
  final bool isOnline;
  final String receiverName,image;
  final int index;
  const ProfileAvatar2({
    super.key,
    this.isOnline = false,
    required this.receiverName, required this.index, required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.1,
      child: Stack(
        children: [
          image==""?CircleAvatar(
            radius:30,
            backgroundColor:  primaryColor ,
            child: Text(
              receiverName.toString().substring(0, 1),
              style: headTextWhite.copyWith(fontSize:25,fontFamily: josefinBold),
            ),
          ):CircleAvatar(
                        radius: 30,
                        backgroundImage: MemoryImage(base64Decode(image)),
                      ),
          Positioned(
              bottom: 0,
              right: 6,
              child: Icon(
                Icons.circle,
                size: 18,
                color: isOnline
                    ? Color.fromARGB(255, 9, 182, 15)
                    : Colors.transparent,
              ))
        ],
      ),
    );
  }
}
