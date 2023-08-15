import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/models/message_model.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:chat_me/utils/time_date_format.dart';
import 'package:chat_me/widgets/profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  final String receiverId, name;
  final bool isOnline;
  final Function()? onTap;
  const UserCard(
      {super.key, required this.receiverId, required this.name, this.onTap, required this.isOnline});

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  MessageModel? _message;
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
                data?.map((e) => MessageModel.fromJson(e.data())).toList() ?? [];
            if (list.isNotEmpty) {
              _message = list[0];
            }
            return ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: widget.onTap,
                    leading: ProfileAvatar2(isOnline:widget.isOnline ,),
                    title: Text(
                      widget.name,
                      style: headTextBlack,
                    ),
                    subtitle: Text(
                      _message != null ? _message!.message : "",
                      style: bodyTextBlack.copyWith(color: Colors.grey),
                    ),
                    trailing: _message == null
                        ? null
                        : _message!.read.isEmpty
                            ? Icon(
                                Icons.circle,
                                size: 17,
                                color: Color.fromARGB(255, 8, 184, 52),
                              )
                            : Text(
                                _message != null
                                    ? TimeDateFormat.getLastMessageTime(
                                        context, _message!.time)
                                    : "",
                                style:
                                    bodyTextBlack.copyWith(color: Colors.grey),
                              ),
                  );
          }),
    );
  }
}
