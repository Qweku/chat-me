import 'dart:developer';
import 'dart:io';

import 'package:chat_me/constants.dart';
import 'package:chat_me/models/message_model.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and Firestore
  final timeformat = DateFormat("HH:mm");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND MESSAGES
  Future<void> sendMessage(String receiverId,Type type, String message) async {
    // get current user info

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUsername = _auth.currentUser!.displayName!;
    final Timestamp timestamp = Timestamp.now();
    final String timeNow = DateTime.now().millisecondsSinceEpoch.toString();

    // create a new message
    MessageModel newMessage = MessageModel(
        senderId: currentUserId,
        message: message,
        read: "",
        receiverId: receiverId,
        type:type,
        time: timeNow,
        senderUsername: currentUsername,
        timestamp: timestamp);

    // construct chat room id for uniqueness b/n current user and receiver
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids to ensure that chat room id is always the same for the same two people
    String chatRoomId = ids.join("_");

    // add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(timestamp.toString())
        .set(newMessage.toJson());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

//Update message read status
  Future<void> updateReadStatus(String receiverId, String timestamp) async {
    final String currentUserId = _auth.currentUser!.uid;
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids to ensure that chat room id is always the same for the same two people
    String chatRoomId = ids.join("_");

    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(timestamp)
        .update({"read": DateTime.now().millisecondsSinceEpoch.toString()});
  }

// Get last message sent or received
  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots();
  }

// Get user info
  Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo(String receiverId) {
    return _fireStore
        .collection('users')
        .where("uid", isEqualTo: receiverId)
        .snapshots();
  }

  // Update Online status of users

  Future<void> updateOnlineStatus(bool isOnline) async {
    _fireStore.collection('users').doc(_auth.currentUser!.uid).update({
      "is_active": isOnline,
      "last_seen": DateTime.now().millisecondsSinceEpoch.toString()
    });
  }

  //Send an image in chat
  Future<void> sendChatImage(
      String message,String receiverId) async {
    return sendMessage(receiverId,Type.image, message);
  }
}
