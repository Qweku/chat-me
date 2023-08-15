import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/screens/chat_page.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:chat_me/widgets/profile_avatar.dart';
import 'package:chat_me/widgets/user_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatService _chatService = ChatService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    _chatService.updateOnlineStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message == AppLifecycleState.paused)
        _chatService.updateOnlineStatus(false);
      if (message == AppLifecycleState.resumed)
        _chatService.updateOnlineStatus(true);
      return Future.value(message);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.circle, color: Color.fromARGB(255, 11, 172, 46)),
          onPressed: () {
           
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "ChatMe",
          style: headTextBlack,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: Colors.grey),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.chat_bubble_outline, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: CustomTextField(
              borderRadius: 20,
              prefixIcon:
                  Icon(Icons.search, color: Color.fromARGB(255, 240, 240, 240)),
              hintText: "Search",
              borderColor: Color.fromARGB(255, 240, 240, 240),
              style: bodyTextBlack.copyWith(fontSize: 16),
            ),
          ),
          //Frequently contacted
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 15),
          //   child: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Padding(
          //         padding: const EdgeInsets.only(left: 15),
          //         child: Text(
          //           "Frequently Contacted",
          //           style: headTextBlack.copyWith(
          //               fontSize: 16, fontFamily: josefinBold),
          //         ),
          //       ),
          //       const SizedBox(
          //         height: 10,
          //       ),
          //       SizedBox(
          //         height: height * 0.1,
          //         child: ListView(
          //           padding: const EdgeInsets.only(left: 15),
          //           shrinkWrap: true,
          //           scrollDirection: Axis.horizontal,
          //           physics: const BouncingScrollPhysics(),
          //           children: List.generate(
          //               7,
          //               (index) => Padding(
          //                     padding: const EdgeInsets.only(right: 10),
          //                     child: ProfileAvatar(),
          //                   )),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(
          //   height: 10,
          // ),
          Expanded(child: _buildUserList())
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            shrinkWrap: true,
            children: snapshot.data!.docs
                .map<Widget>((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current user
    if (auth.currentUser!.email != data['email']) {
      return UserCard(
        isOnline: isActive,
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatPage(
                        receiverUserID: data['uid'],
                        receiverUserName: data['username'],
                      )));
        },
        name: data['username'],
        receiverId: data['uid'],
      );
    } else {
      return Container();
    }
  }
}