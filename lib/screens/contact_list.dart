import 'dart:developer';

import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:chat_me/provider/contact_provider.dart';
import 'package:chat_me/screens/chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  bool isSearch = false;
  String query = '';
  TextEditingController searchController = TextEditingController();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  List<UserModel> suggestions = [];
  final auth = FirebaseAuth.instance;

  Future getUsers() async {
    QuerySnapshot data = await fireStore.collection('users').get();

    for (QueryDocumentSnapshot snapshot in data.docs) {
      log("${snapshot["uid"]}:${snapshot["username"]}");
      UserModel contacts = UserModel(
        uid: snapshot["uid"],
        displayName: snapshot["username"],
        email: snapshot["email"],
        pushToken: snapshot["push_Token"]
      );

      suggestions.add(contacts);
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Contacts",
            style: headTextWhite,
          ),
          backgroundColor: primaryColor,
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearch = !isSearch;
                  });
                },
                icon: Icon(
                  !isSearch ? Icons.search : Icons.close,
                  color: Colors.white,
                ))
          ],
          bottom: !isSearch
              ? PreferredSize(
                  child: Container(), preferredSize: Size.fromHeight(0))
              : PreferredSize(
                  preferredSize: Size.fromHeight(height * 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: CustomTextField(
                      //controller: searchController,
                      borderColor: Colors.white,
                      style: bodyTextWhite.copyWith(fontSize: 16),
                      hintText: 'Search',
                      hintColor: Colors.white,
                      suffixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onChanged: (text) {
                        setState(() {
                          query = text;
                        });
                      },
                    ),
                  )),
        ),
        body: !isSearch ? _buildContactList() : _buildSearchContactList());
  }

  Widget _buildContactList() {
    return context.read<ContactProvider>().contactList.isEmpty
        ? SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.contacts,
                  color: Colors.grey,
                  size: 70,
                ),
                SizedBox(height: 20),
                Text(
                  "No contacts",
                  style: headTextBlack.copyWith(color: Colors.grey),
                )
              ],
            ),
          )
        : ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: List.generate(
                context.watch<ContactProvider>().contactList.length,
                (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    onLongPress: ()=>_bottomDrawSheet(context, context
                                            .read<ContactProvider>()
                                            .contactList[index]),
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => ChatPage(
                          //               receiverUserID: context
                          //                   .read<ContactProvider>()
                          //                   .contactList[index]
                          //                   .uid,
                          //               receiverUserName: context
                          //                       .read<ContactProvider>()
                          //                       .contactList[index]
                          //                       .displayName ??
                          //                   "",
                          //             )));
                        },
                        leading: CircleAvatar(
                          backgroundColor: lightGreyColor,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey,
                          ),
                        ),
                        title: Text(
                          context
                                  .read<ContactProvider>()
                                  .contactList[index]
                                  .displayName ??
                              "No username",
                          style: headTextBlack,
                        ),
                        trailing: Icon(
                          Icons.message,
                          size: 16,
                          color: secondaryColor,
                        ),
                      ),
                )),
          );
  }

  Widget _buildSearchContactList() {
    var searchData = suggestions
        .where((element) =>
            element.displayName!.toLowerCase().contains(query.toLowerCase()) &&
            auth.currentUser!.email != element.email)
        .toList();
    return searchData.isEmpty
        ? SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                  size: 70,
                ),
                SizedBox(height: 20),
                Text(
                  "Not found",
                  style: headTextBlack.copyWith(color: Colors.grey),
                )
              ],
            ),
          )
        : ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(20),
            shrinkWrap: true,
            children: List.generate(
                searchData.length,
                (index) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: lightGreyColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        ),
                      ),
                      title: Text(
                        searchData[index].displayName ?? "No username",
                        style: headTextBlack,
                      ),
                      trailing: GestureDetector(
                        onTap: () {
                          if (!Provider.of<ContactProvider>(context,
                                  listen: false)
                              .contactList
                              .contains(searchData[index])) {
                            Provider.of<ContactProvider>(context, listen: false)
                                .addContact(searchData[index]);
                          }
                        },
                        child:
                            Provider.of<ContactProvider>(context, listen: false)
                                    .contactList
                                    .contains(searchData[index])
                                ? Text(
                                    'added',
                                    style: bodyTextBlack.copyWith(
                                        color: Colors.grey),
                                  )
                                : Icon(
                                    Icons.add_circle,
                                    color: secondaryColor,
                                  ),
                      ),
                    )),
          );
  }

  void _bottomDrawSheet(BuildContext context, UserModel contact) {
    double height = MediaQuery.of(context).size.height;
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(height * 0.02),
            child: Wrap(
              spacing: 20,
              children: <Widget>[
                SizedBox(height: height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: primaryColor,
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Edit', style: bodyTextBlack)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Provider.of<ContactProvider>(context, listen: false)
                            .deleteContact(contact);

                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: secondaryColor,
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Remove', style: bodyTextBlack)
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
              ],
            ),
          );
        });
  }
}
