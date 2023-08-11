import 'package:chat_me/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ContactProvider extends ChangeNotifier {
  LocalStorage localStorage = LocalStorage('contacts');
  List<UserModel> _contactList = [];

  List<UserModel> get contactList => _contactList;

  set contactList(List<UserModel> contacts) {
    _contactList = contacts;
    notifyListeners();
  }

  void addContact(UserModel contactUser) async {
    _contactList.add(contactUser);
    notifyListeners();
    await localStorage.setItem('user_contact', userModelToJson(_contactList));
  }

  void deleteContact(UserModel contact) async{
    _contactList.remove(contact);
    notifyListeners();
    await localStorage.setItem('user_contact', userModelToJson(_contactList));
  }
}
