// lib/backend/schema/recent_chats_struct.dart

/// Represents a single chat item in "Recent Chats".
class RecentChatItem {
  final String receivedOn;
  final String message;
  final String lastMessageBy;

  RecentChatItem({
    required this.receivedOn,
    required this.message,
    required this.lastMessageBy,
  });
}
