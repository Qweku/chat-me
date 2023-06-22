import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/screens/chat_page.dart';
import 'package:chat_me/services/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: primaryColor,
          title: Text(
            "Chat Me",
            style: headTextWhite,
          ),
          actions: [
            IconButton(
                onPressed: () => authService.signOut(),
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings, color: Colors.white))
          ],
        ),
        body: _buildUserList());
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
            padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 20),
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
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiverUserID: data['uid'],
                          receiverUserName: data['username'],
                        )));
          },
          leading: CircleAvatar(
            backgroundColor: lightGreyColor,
            radius: 25,
            child: Text(
              data['username'].toString().substring(0,1),
              style: headTextWhite.copyWith(color:primaryColor),
            ),
          ),
          title: Text(
            data['username'],
            style: headTextBlack,
          ),
          subtitle: Text(data['email'],style:bodyTextBlack.copyWith(color:Colors.grey)),
          trailing: const Icon(Icons.message,color: Colors.grey,size:17)
        ),
      );
    } else {
      return Container();
    }
  }
}
