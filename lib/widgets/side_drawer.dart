import 'dart:convert';

import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/screens/profile/profile.dart';
import 'package:chat_me/services/chat_services.dart';
import 'package:chat_me/services/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawer extends StatefulWidget {
  final String profileImage;
  const SideDrawer({
    super.key, required this.profileImage,
  });

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
 final ChatService _chatService = ChatService();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final FirebaseAuth auth = FirebaseAuth.instance;
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            width: width,
            height: height * 0.3,
            child: DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Column(children: [
                widget.profileImage == ""
                    ? CircleAvatar(
                        radius: 50,
                        backgroundColor: secondaryColor,
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 50,
                        backgroundImage: MemoryImage(base64Decode(widget.profileImage)),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(auth.currentUser!.displayName!,
                      style: headTextWhite),
                ),
                Text(
                  auth.currentUser!.email!,
                  style: bodyTextWhite,
                )
              ]),
            ),
          ),
          DrawerItem(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
              Scaffold.of(context).closeDrawer();
              return;
            },
            text: 'Settings',
            icon: Icons.settings,
          ),
          DrawerItem(
            onTap: () {
               authService.signOut();
                _chatService.updateOnlineStatus(false);
            },
            text: 'Logout',
            icon: Icons.logout,
          ),
        ],
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final Function()? onTap;
  const DrawerItem({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Icon(icon, color: secondaryColor),
        title: Text(text,
            style: bodyTextBlack.copyWith(fontSize: 14, color: primaryColor)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: primaryColor,
          size: 15,
        ),
        onTap: onTap);
  }
}
