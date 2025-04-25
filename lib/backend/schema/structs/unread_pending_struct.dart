// lib/backend/schema/unread_pending_struct.dart

/// A pure data class (struct) for the "Unread & Pending" info.
class UnreadPendingData {
  final int unreadChatsCount;
  final String unreadChatsLabel;
  final int pendingTasksCount;
  final int totalTasksCount;
  final String pendingLabel;

  UnreadPendingData({
    required this.unreadChatsCount,
    required this.unreadChatsLabel,
    required this.pendingTasksCount,
    required this.totalTasksCount,
    required this.pendingLabel,
  });

  // If you need JSON serialization:
  // factory UnreadPendingData.fromJson(Map<String, dynamic> json) { ... }
  // Map<String, dynamic> toJson() { ... }
}
