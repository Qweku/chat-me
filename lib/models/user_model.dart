import 'dart:convert';

List<UserModel> userModelFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

String userModelToJson(List<UserModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? userImage;
  final bool? isActive;
  final String? lastSeen;
  final String? pushToken;

  UserModel(
      {this.isActive,
      required this.uid,
      this.email,
      this.lastSeen,
      this.displayName,
      this.pushToken,
      this.userImage});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email ?? '',
      'username': displayName ?? "",
      'last_seen': lastSeen ?? "",
      'user_image': userImage ?? "",
      'push_Token':pushToken ?? "",
      'is_active': isActive ?? false
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uid: json["uid"],
        email: json["email"],
        displayName: json["username"],
        lastSeen: json["last_seen"],
        userImage: json["user_image"],
        pushToken: json["push_Token"],
        isActive: (json['is_active'] == null) ? false : (json['is_active']),
      );
}
