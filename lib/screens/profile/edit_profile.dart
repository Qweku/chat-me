import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController bio = TextEditingController();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit",
          style: headTextWhite,
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              onPressed: () async{
                fireStore
                    .collection('users')
                    .doc(_auth.currentUser!.uid)
                    .update({'bio': bio.text}).then((value) => bio.clear());
              },
              icon: Icon(Icons.check, color: Colors.white))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("Edit bio",
              style: headTextBlack.copyWith(fontSize: 16, color: Colors.grey)),
          SizedBox(height: 10),
          CustomTextField(
            controller: bio,
            borderColor: Colors.grey,
            style: bodyTextBlack.copyWith(fontSize: 16),
            hintText: "Enter your bio",
            borderRadius: 20,
          )
        ]),
      ),
    );
  }
}
