import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:chat_me/models/message_model.dart';
import 'package:chat_me/components/chat_bubble.dart';
import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:chat_me/utils/time_date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName, receiverUserID,receiverPushToken;
  const ChatPage(
      {super.key,
      required this.receiverUserName,
      required this.receiverUserID, required this.receiverPushToken});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  File? _image;
  String imageString = '';
  bool isImage = false;
  String pushToken = "";

//get user push token
Future<void> getPushToken() async {
    try {
      QuerySnapshot data = await fireStore.collection("users").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        // Check if current user id exist in database
        if (_auth.currentUser!.uid == snapshot["uid"]) {
          setState(() {
            pushToken = snapshot["push_Token"];
           
           
          });
          log(pushToken);
        }
      }
    } on FirebaseException catch (e) {
      log(e.toString());
    }
  }


  //send message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID,widget.receiverPushToken, Type.text, messageController.text);
      //clear controller after sending a message
      messageController.clear();
    }
  }

@override
  void initState() {
    getPushToken();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        title: StreamBuilder(
            stream: _chatService.getUserInfo(widget.receiverUserID),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final list =
                  data?.map((e) => UserModel.fromJson(e.data())).toList() ?? [];

              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: list.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage:
                            MemoryImage(base64Decode(list[0].userImage!)),
                      )
                    : CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 240, 240, 240),
                        child: Text(
                          widget.receiverUserName.toString().substring(0, 1),
                          style: headTextWhite.copyWith(color: primaryColor),
                        ),
                      ),
                title: Text(
                  widget.receiverUserName,
                  style: headTextWhite,
                ),
                subtitle: list.isNotEmpty
                    ? Text(
                        list[0].isActive!
                            ? "online"
                            : TimeDateFormat()
                                .getLastActiveTime(context, list[0].lastSeen!),
                        style: bodyTextWhite,
                      )
                    : Container(),
              );
            }),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_outlined, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: _buildMessageList(),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: _buildMessageInput(),
        )
      ]),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
        stream: _chatService.getMessages(
            widget.receiverUserID, _auth.currentUser!.uid),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "An Error Occured while fetching data",
                style: headTextBlack.copyWith(color: Colors.grey),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            reverse: true,
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList()
                .reversed
                .toList(),
          );
        }));
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    //align the messages according to sender and receiver
    var alignment = (data['senderId'] == _auth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
          crossAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _auth.currentUser!.uid)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            (data['senderId'] == _auth.currentUser!.uid)
                ? SenderChatBubble(
                    type: data['type'] ?? "",
                    read: data['read'],
                    time: TimeDateFormat.getTimeformat(context, data['time']),
                    message: data['message'],
                    color: primaryColor)
                : ChatBubble(
                    type: data['type'],
                    receiverId: widget.receiverUserID,
                    timestamp: data['timestamp'].toString(),
                    read: data['read'],
                    time: TimeDateFormat.getTimeformat(context, data['time']),
                    message: data['message'],
                    color: Color.fromARGB(255, 241, 241, 241),
                  ),
            const SizedBox(height: 10),
          ]),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            borderRadius: 20,
            suffixIcon: SizedBox(
              width: width * 0.3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.image,
                      color: primaryColor,
                      size: 17,
                    ),
                    onPressed: () => _imgFromGallery(),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: primaryColor,
                      size: 17,
                    ),
                    onPressed: () => _imgFromCamera(),
                  ),
                ],
              ),
            ),
            borderColor: lightGreyColor,
            hintText: 'Type message here',
            controller: messageController,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        CircleAvatar(
          backgroundColor: secondaryColor,
          child: IconButton(
              onPressed: () {
                sendMessage();
                FocusScope.of(context).unfocus();
              },
              icon: Icon(Icons.arrow_upward, size: 17, color: Colors.white)),
        )
      ],
    );
  }

  Future _imgFromCamera() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      // final toBytes = await
      setState(() {
        _image = File(image!.path);
        imageString = base64Encode(File(image.path).readAsBytesSync());

        _chatService.sendChatImage(imageString,pushToken, widget.receiverUserID);
      });
    } catch (e) {}
  }

  _imgFromGallery() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      setState(() {
        _image = File(image!.path);

        imageString = base64Encode(File(image.path).readAsBytesSync());
        _chatService.sendChatImage(imageString,pushToken, widget.receiverUserID);
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
