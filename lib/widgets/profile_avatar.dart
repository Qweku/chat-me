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
  const ProfileAvatar2({
    super.key, this.isOnline = false,
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
              bottom: 0,
              right: 6,
              child: Icon(
                Icons.circle,
                size: 18,
                color:  isOnline? Color.fromARGB(255, 9, 182, 15):Colors.transparent,
              ))
             
        ],
      ),
    );
  }
}
