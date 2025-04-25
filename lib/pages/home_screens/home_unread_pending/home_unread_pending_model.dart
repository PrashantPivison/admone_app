// lib/pages/home_screens/unread_pending_model.dart

import 'package:flutter/material.dart';
import 'package:my_app/backend/schema/structs/unread_pending_struct.dart';

class HomeUnreadPendingModel extends ChangeNotifier {
  // Store the struct internally
  UnreadPendingData _data = UnreadPendingData(
    unreadChatsCount: 1,
    unreadChatsLabel: 'data',
    pendingTasksCount: 2,
    totalTasksCount: 2,
    pendingLabel: 'pending vs all',
  );

  // GETTERS matching the old widget references:
  int get unreadChatsCount => _data.unreadChatsCount;
  String get unreadChatsLabel => _data.unreadChatsLabel;
  int get pendingTasksCount => _data.pendingTasksCount;
  int get totalTasksCount => _data.totalTasksCount;
  String get pendingLabel => _data.pendingLabel;

  // Example async method to update data
  Future<void> loadData() async {
    await Future.delayed(const Duration(seconds: 1));
    _data = UnreadPendingData(
      unreadChatsCount: 3,
      unreadChatsLabel: 'new label',
      pendingTasksCount: 5,
      totalTasksCount: 10,
      pendingLabel: 'pending vs total',
    );
    notifyListeners();
  }
}
