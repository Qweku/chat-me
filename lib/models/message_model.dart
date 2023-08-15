import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId, senderUsername, receiverId, message,read, time;
  final Timestamp timestamp;
  

  MessageModel(
      {required this.senderId,required this.read, 
      required this.message,
      required this.receiverId,
      required this.senderUsername,
      required this.time,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'read':read,
      'senderUsername':senderUsername,
      'receiverId':receiverId,
      'message':message,
      'time':time,
      'timestamp':timestamp
    };
  }
  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        senderId: json["senderId"],
        read:json["read"],
        senderUsername: json["senderUsername"],
        receiverId: json["receiverId"],
        message: json["message"],
        time: json["time"],
        timestamp: json["timestamp"],
        
      );
}
