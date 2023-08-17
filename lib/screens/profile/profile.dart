import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_me/config/app_colors.dart';
import 'package:chat_me/config/app_text.dart';
import 'package:chat_me/constants.dart';
import 'package:chat_me/screens/profile/edit_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ScrollController _scrollController = ScrollController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final picker = ImagePicker();
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  File? _image;
  String bio = "";
  String imageString = '';
  Future<void> getImage() async {
    try {
      QuerySnapshot data = await fireStore.collection("users").get();

      for (QueryDocumentSnapshot snapshot in data.docs) {
        // Check if current user id exist in database
        if (_auth.currentUser!.uid == snapshot["uid"]) {
          setState(() {
            imageString = snapshot["user_image"];
            profileImg = snapshot["user_image"];
            bio=snapshot["bio"] ?? "";
          });
          log(imageString);
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
    return DefaultTabController(
        length: 1,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 300,
                floating: false,
                automaticallyImplyLeading: false,
                pinned: true,
                backgroundColor: primaryColor,
                actions: <Widget>[
                  IconButton(
                    icon: const Icon(Icons.edit, size: 26, color: Colors.white),
                    onPressed: () {},
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 20, bottom: 20),
                  title: Text(
                    _auth.currentUser!.displayName!,
                    style: headTextWhite.copyWith(
                        fontSize: 25, fontFamily: josefinBold),
                  ),
                  background: imageString == ""
                      ? Container(
                          alignment: Alignment(0.8, 0.9),
                          height: 300,
                          color: primaryColor,
                          child: GestureDetector(
                            onTap: () => _attachImage(context),
                            child: CircleAvatar(
                              backgroundColor: secondaryColor,
                              radius: 35,
                              child: Icon(Icons.camera_alt_outlined,
                                  color: Colors.white),
                            ),
                          ))
                      : Container(
                          alignment: Alignment(0.8, 0.9),
                          height: 300,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              image: DecorationImage(
                                
                                  image: MemoryImage(
                                      base64Decode(imageString)),
                                  fit: BoxFit.cover,)),
                          child: GestureDetector(
                            onTap: () => _attachImage(context),
                            child: CircleAvatar(
                              backgroundColor: secondaryColor,
                              radius: 35,
                              child: Icon(Icons.camera_alt_outlined,
                                  color: Colors.white),
                            ),
                          )),
                ),
              )
            ];
          },
          body: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text("Account",style: headTextBlack.copyWith(color: primaryColor,fontFamily: josefinBold),),
                SizedBox(width: width*0.1,
                child: Divider(thickness: 3,color: secondaryColor,),),
                SizedBox(height: 20,),
                ListTile(
                  title: Text(_auth.currentUser!.displayName!,style:headTextBlack),
                  subtitle: Text("username",style: bodyTextBlack.copyWith(color: Colors.grey),),
                ),
                Divider(color: Color.fromARGB(255, 238, 238, 238),),
                 ListTile(
                  title: Text(_auth.currentUser!.email!,style:headTextBlack),
                  subtitle: Text("email",style: bodyTextBlack.copyWith(color: Colors.grey),),
                ),
                 Divider(color: Color.fromARGB(255, 238, 238, 238),),
                 ListTile(
                  onTap: (){
                      Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfile()));
                  },
                  title: Text(bio==""?"No bio":bio,style:headTextBlack),
                  subtitle: Text("bio",style: bodyTextBlack.copyWith(color: Colors.grey),),
                ),
                
              ]),
            ),
          ),
        ));
  }

  void _attachImage(context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
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
                        _imgFromGallery();
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: Color.fromARGB(255, 241, 241, 241),
                            child: Icon(Icons.cloud_upload_outlined,
                                color: secondaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Upload', style: bodyTextBlack)
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _imgFromCamera();
                        Navigator.pop(context);
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: height * 0.04,
                            backgroundColor: Color.fromARGB(255, 241, 241, 241),
                            child:
                                Icon(Icons.camera_alt, color: secondaryColor),
                          ),
                          SizedBox(height: height * 0.01),
                          Text('Take Photo', style: bodyTextBlack)
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

  Future _imgFromCamera() async {
    try {
      final image =
          await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
      // final toBytes = await
      setState(() {
        _image = File(image!.path);
        imageString = base64Encode(File(image.path).readAsBytesSync());
        fireStore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'user_image': imageString});
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
      fireStore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({'user_image': imageString});
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
