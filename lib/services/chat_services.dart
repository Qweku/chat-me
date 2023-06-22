import 'package:chat_me/models/message_model.dart';
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
  Future<void> sendMessage(String receiverId, String message) async {
    // get current user info

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUsername = _auth.currentUser!.displayName!;
    final Timestamp timestamp = Timestamp.now();
    final String timeNow = timeformat.format(DateTime.now());

    // create a new message
    MessageModel newMessage = MessageModel(
        senderId: currentUserId,
        message: message,
        receiverId: receiverId,
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
        .add(newMessage.toMap());
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
}
