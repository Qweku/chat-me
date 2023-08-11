import 'package:chat_me/models/chat_model.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';

class ChatProvider extends ChangeNotifier {
  LocalStorage localStorage = LocalStorage('chats');
  List<ChatModel> _chatList = [];

  List<ChatModel> get chatList => _chatList;

  void addChat(ChatModel chatModel) async {
    _chatList.add(chatModel);
    notifyListeners();
    await localStorage.setItem('user_chat', chatModelToJson(_chatList));
  }

  void deleteChat(ChatModel chat)async {
    _chatList.remove(chat);
    notifyListeners();
    await localStorage.setItem('user_chat', chatModelToJson(_chatList));
  }
}
