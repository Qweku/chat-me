import 'dart:developer';

import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message, time;

  final Color color;
  const ChatBubble({
    super.key,
    required this.message,
    required this.color,
   
    required this.time,
    
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.5),
          // width: width*0.2,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            color: color,
          ),
          child:
              Text(message, style: bodyTextBlack.copyWith(fontSize: 15)),
        ),
        const SizedBox(height: 7),
        Text(
          time,
          style: bodyTextBlack.copyWith(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  final String message, read, time, receiverId, timestamp;
  final Color color;
  const SenderChatBubble(
      {super.key,
      required this.message,
      required this.color,
      required this.time, required this.read, required this.receiverId, required this.timestamp});

  @override
  Widget build(BuildContext context) {
     if (read.isEmpty) {
      ChatService().updateReadStatus(receiverId, timestamp);
      log("message read");
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: width * 0.8),
          // width: width*0.2,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
            color: color,
          ),
          child: Text(message, style: bodyTextWhite.copyWith(fontSize: 15)),
        ),
        const SizedBox(height: 7),
         Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
           
          
            Text(
              time,
              style: bodyTextBlack.copyWith(color: Colors.grey, fontSize: 12),
            ),  SizedBox(width: 7), 
          read.isNotEmpty
                ? Icon(Icons.done_all_rounded,size: 15, color: Colors.blue)
                : Container(),
          ],
        ),
      ],
    );
  }
}
