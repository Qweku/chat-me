import 'dart:convert';

List<ChatModel> chatModelFromJson(String str) =>
    List<ChatModel>.from(json.decode(str).map((x) => ChatModel.fromJson(x)));

String chatModelToJson(List<ChatModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class ChatModel {
  final int id;
  final String userName, lastMessage, lastMessageTime;
  final String? userImage;
  final int newMessageQuantity;

  ChatModel(
      {required this.id,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.newMessageQuantity,
      this.userImage,
      required this.userName});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': userName,
      'lastmessage': lastMessage,
      'last_message_time': lastMessage,
      'new_message_quantity': newMessageQuantity,
      'user_image': userImage ?? "",
    };
  }

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
      id: json["id"],
      userName: json["username"],
      lastMessage: json["last_message"],
      userImage: json["user_image"],
      lastMessageTime: json["last_message_time"],
      newMessageQuantity: json["new_message_quantity"]);
}
