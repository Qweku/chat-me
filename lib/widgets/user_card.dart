import 'dart:developer';

import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/models/message_model.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:chat_me/utils/time_date_format.dart';
import 'package:chat_me/widgets/profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String receiverId, name;
  final int index;
  final bool isOnline;
  final Function()? onTap;
  const UserCard(
      {super.key,
      required this.receiverId,
      required this.name,
      this.onTap,
      required this.isOnline,
      required this.index});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
   FirebaseFirestore fireStore = FirebaseFirestore.instance;
String imageString = '';  
MessageModel? _message;
  Future<void> getImage() async {
    try {
      QuerySnapshot data = await fireStore.collection("users").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        // Check if current user id exist in database
        if (widget.receiverId == snapshot["uid"]) {
          setState(() {
            imageString = snapshot["user_image"];
          });
        }
      }
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }


  @override
  void initState() {
    getImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: StreamBuilder(
          stream: _chatService.getLastMessage(
              _auth.currentUser!.uid, widget.receiverId),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => MessageModel.fromJson(e.data())).toList() ??
                    [];
            if (list.isNotEmpty) {
              _message = list[0];
            }
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  onTap: widget.onTap,
                  leading: ProfileAvatar2(
                    image: imageString,
                    index: widget.index,
                    receiverName: widget.name,
                    isOnline: widget.isOnline,
                  ),
                  title: Text(
                    widget.name,
                    style: headTextBlack,
                  ),
                  subtitle: _message != null && _message!.type == "text"
                      ? Text(
                          _message!.message,
                          style: bodyTextBlack.copyWith(color: Colors.grey),
                        )
                      : _message == null
                          ? Text(
                              "new user",
                              style: bodyTextBlack.copyWith(color: Colors.grey),
                            )
                          : Padding(
                            padding: const EdgeInsets.only(top:8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.image, color: Colors.grey),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    "Photo",
                                    style: bodyTextBlack.copyWith(
                                        color: Colors.grey),
                                  )
                                ],
                              ),
                          ),
                  trailing: _message == null
                      ? null
                      : _message!.read.isEmpty &&
                             _message!.senderId != _auth.currentUser!.uid
                          ? Icon(
                              Icons.circle,
                              size: 17,
                              color: Color.fromARGB(255, 8, 184, 52),
                            )
                          : Text(
                              _message != null
                                  ? TimeDateFormat.getLastMessageTime(
                                      context, _message!.time)
                                  : "New",
                              style: bodyTextBlack.copyWith(color: Colors.grey),
                            ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 50),
                  child: Divider(
                    color: Color.fromARGB(255, 216, 216, 216),
                  ),
                )
              ],
            );
          }),
    );
  }
}
