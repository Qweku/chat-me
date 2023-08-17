import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String senderId, senderUsername, receiverId, message, read, time;
  final Timestamp timestamp;
  final Type type;

  MessageModel(
      {required this.senderId,
      required this.read,
      required this.message,
      required this.receiverId,
      required this.senderUsername,
      required this.time,
      required this.type,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'read': read,
      'senderUsername': senderUsername,
      'receiverId': receiverId,
      'message': message,
      'time': time,
      'type': type.name,
      'timestamp': timestamp
    };
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['senderId'] = senderId;
    data['read'] = read;
    data['senderUsername'] = senderUsername;
    data['receiverId'] = receiverId;
    data['message'] = message;
    data['time'] = time;
    data['type'] = type.name;
    data['timestamp'] = timestamp;

    return data;
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        senderId: json["senderId"],
        read: json["read"],
        senderUsername: json["senderUsername"],
        receiverId: json["receiverId"],
        message: json["message"],
        time: json["time"],
        type:
            json["type"].toString() == Type.image.name ? Type.image : Type.text,
        timestamp: json["timestamp"],
      );
}

enum Type { text, image }
