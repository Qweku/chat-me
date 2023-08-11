import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;

  final Color color;
  const ChatBubble(
      {super.key,
      required this.message,
      required this.color,
      });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Text(message, style: bodyTextBlack.copyWith(fontSize: 15)),
    );
  }
}

class SenderChatBubble extends StatelessWidget {
  final String message;
  final Color color;
  const SenderChatBubble(
      {super.key, required this.message, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}