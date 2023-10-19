import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:chat_me/main.dart';
import 'package:chat_me/models/message_model.dart';
import 'package:chat_me/models/user_model.dart';
import 'package:chat_me/screens/chat_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {}

class ChatService extends ChangeNotifier {
  // get instance of auth and Firestore
  final timeformat = DateFormat("HH:mm");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //for storing self info
  late UserModel me;

  // get firebase messaging instance
  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  //SEND MESSAGES
  Future<void> sendMessage(
      String receiverId, String pushToken, Type type, String message) async {
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
        type: type,
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
        .set(newMessage.toJson())
        .then((value) => sendNotification(currentUsername, pushToken,
            type.name == "text" ? message : "image"));
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

// get current use info
  Future<void> getSelfInfo(bool isActive) async {
    await _fireStore
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((user) async {
      if (user.exists) {
        me = UserModel.fromJson(user.data()!);
        await getFMToken();

        //setting user online status
        updateOnlineStatus(isActive);
        //log("My data: ${user.data()}");
      }
    });
  }

  // Update Online status of users

  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      await _fireStore.collection('users').doc(_auth.currentUser?.uid).update({
        "is_active": isOnline,
        "last_seen": DateTime.now().millisecondsSinceEpoch.toString(),
        "push_Token": me.pushToken
      });
    } catch (e) {
      log(e.toString());
    }
  }

  //Send an image in chat
  Future<void> sendChatImage(
      String message, String pushToken, String receiverId) async {
    return sendMessage(receiverId, pushToken, Type.image, message);
  }

  // get firebase messaging token
  Future<void> getFMToken() async {
    await fMessaging.requestPermission();
    await fMessaging.getToken().then((t) {
      if (t != null) {
        me.pushToken = t;
        log(t);
      }
    });
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (BuildContext context) => ChatList()));
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    // FirebaseMessaging.onMessage.listen((message) {
    //   final notification = message.notification;
    //   if (notification == null) return;
    //   _localNotifications.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //           android: AndroidNotificationDetails(
    //         _androidChannel.id,
    //         _androidChannel.name,
    //         channelDescription: _androidChannel.description,
    //         icon: '@mipmap/ic_launcher',
    //       )),
    //       payload: jsonEncode(message.toMap()));
    // });
  }

  //send notification using google api
  Future<void> sendNotification(
      String senderName, String pushToken, String msg) async {
    try {
      final body = {
        "to": pushToken,
        "notification": {"title": senderName, "body": msg}
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA139qlMA:APA91bEMkZLdXq2nb3t36r-2QlNBV_3-xTP4SPpQn7mTjCdbHRX3GOm0g4j2zIoAZFjRugAiHBLxehoBt-lF2NwF8IerrmEpBqbmbZIc8nXKKhG5YUGNcMJl0EjWhmDhElOsmhPt5e1p'
              },
              body: jsonEncode(body));

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");
    } catch (e) {
      log("sendNotification: $e");
    }
  }
}
