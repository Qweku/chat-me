import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId, senderUsername, receiverId, message;
  final Timestamp timestamp;

  MessageModel(
      {required this.senderId,
      required this.message,
      required this.receiverId,
      required this.senderUsername,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderUsername':senderUsername,
      'receiverId':receiverId,
      'message':message,
      'timestamp':timestamp
    };
  }
}