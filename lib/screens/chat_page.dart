import 'package:chat_me/components/chat_bubble.dart';
import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserName, receiverUserID;
  const ChatPage(
      {super.key,
      required this.receiverUserName,
      required this.receiverUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //send message
  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, messageController.text);
      //clear controller after sending a message
      messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            child: Icon(Icons.person, color: Colors.grey),
          ),
          title: Text(
            widget.receiverUserName,
            style: headTextBlack,
          ),
          subtitle: Text(
            "online",
            style: bodyTextBlack,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.phone_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.video_call_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.flag_outlined, color: Colors.grey),
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
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        }));
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
 final timeformat = DateFormat("HH:mm");
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
            (data['senderId'] == _auth.currentUser!.uid)?SenderChatBubble(
              message: data['message'],
              color: 
                   primaryColor
                  
            ):ChatBubble(
              message: data['message'],
              color:  Color.fromARGB(255, 241, 241, 241),
            ),
            const SizedBox(height:7),
            Text( data['time'],style: bodyTextBlack.copyWith(color: Colors.grey,fontSize: 12),),
            const SizedBox(height:10),
          ]),
    );
  }

  Widget _buildMessageInput() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            borderColor: lightGreyColor,
            hintText: 'Type message here',
            controller: messageController,
          ),
        ),
        const SizedBox(width: 10,),
        CircleAvatar(
          radius:25,
          backgroundColor: secondaryColor,
          child: IconButton(
              onPressed:(){
        sendMessage();
        FocusScope.of(context).unfocus();
              }, 
              icon: Icon(Icons.send, color: Colors.white)),
        )
      ],
    );
  }
}
