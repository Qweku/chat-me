import 'dart:developer';

import 'package:chat_me/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  UserModel? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        userImage: user.photoURL);
  }

  Stream<UserModel?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  // login user
  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    // create a firestore collection for users
    await _firebaseFirestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'username': credential.user!.displayName ?? "new user"
    }, SetOptions(merge: true));
    return _userFromFirebase(credential.user);
  }

// create a new user
  Future<UserModel?> createUserWithEmailAndPassword(
      String displayName, String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await credential.user!.updateDisplayName(displayName);
    // create a firestore collection for users
    await _firebaseFirestore.collection('users').doc(credential.user!.uid).set({
      'uid': credential.user!.uid,
      'email': email,
      'username': displayName,
      'last_seen': "",
      'user_image': "",
      'push_Token': "",
      'is_active': false
    }, SetOptions(merge: true));
    return _userFromFirebase(credential.user);
  }

// logout from app
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> forgottenPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      log(e.toString());
    }
  }
}
