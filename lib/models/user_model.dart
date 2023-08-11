

import 'dart:convert';

List<UserModel> userModelFromJson(String str) => List<UserModel>.from(
    json.decode(str).map((x) => UserModel.fromJson(x)));

    String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? userImage;

  UserModel({required this.uid, this.email, this.displayName, this.userImage});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email?? '',
      'username': displayName ?? "",
      'user_image':userImage ?? ""
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
       displayName: json["username"],
       userImage: json["user_image"],
       
      );
}
