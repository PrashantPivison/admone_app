// lib/pages/home_screens/recent_chats_model.dart

import 'package:flutter/material.dart';
import 'package:my_app/backend/schema/structs/recent_chats_struct.dart';

class HomeRecentChatsModel extends ChangeNotifier {
  // Private list of recent chats
  List<RecentChatItem> _recentChats = [
    RecentChatItem(
      receivedOn: '2025-02-05 10:30 AM',
      message: 'Hello, how are you bro?',
      lastMessageBy: 'John Doe',
    ),
    RecentChatItem(
      receivedOn: '2025-02-05 10:35 AM',
      message: 'Are you there?',
      lastMessageBy: 'Jane Smith',
    ),
  ];

  // GETTER so widgets can read model.recentChats
  List<RecentChatItem> get recentChats => _recentChats;

  // Example async method to load or update the list
  Future<void> loadChats() async {
    await Future.delayed(const Duration(seconds: 1));
    _recentChats.add(
      RecentChatItem(
        receivedOn: '2025-02-06 11:00 AM',
        message: 'New chat message',
        lastMessageBy: 'Alice',
      ),
    );
    notifyListeners();
  }
}
