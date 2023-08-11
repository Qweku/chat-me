import 'package:chat_me/components/textField-widget.dart';
import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

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
        title: Text(
          "Direct Message",
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical:15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Frequently Contacted",
                    style: headTextBlack.copyWith(
                        fontSize: 16, fontFamily: josefinBold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: height * 0.1,
                  child: ListView(
                    padding: const EdgeInsets.only(left: 15),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(
                        7,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: ProfileAvatar(),
                            )),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                  10,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ListTile(
                          leading: ProfileAvatar2(),
                          title: Text(
                            "Rosa",
                            style: headTextBlack,
                          ),
                          subtitle: Text(
                            "last message blah blah blah blah",
                            style: bodyTextBlack.copyWith(color:Colors.grey),
                          ),
                          trailing: Text("1 minute ago",style: bodyTextBlack.copyWith(color: Colors.grey),),
                        ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.1,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            child: Icon(Icons.person, color: Colors.grey),
            radius: 35,
          ),
          Positioned(
              bottom: height * 0.03,
              right: 2,
              child: Icon(
                Icons.circle,size: 18,
                color: Color.fromARGB(255, 9, 182, 15),
              ))
        ],
      ),
    );
  }
}
class ProfileAvatar2 extends StatelessWidget {
  const ProfileAvatar2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.1,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Color.fromARGB(255, 240, 240, 240),
            child: Icon(Icons.person, color: Colors.grey),
            radius: 35,
          ),
          Positioned(
              bottom: 0,
              right:6,
              child: Icon(
                Icons.circle,size: 18,
                color: Color.fromARGB(255, 9, 182, 15),
              ))
        ],
      ),
    );
  }
}
