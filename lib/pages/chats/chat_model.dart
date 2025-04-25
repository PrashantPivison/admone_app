// lib/models/chat_model.dart

class ClientDetail {
  final int id;
  final String name;

  ClientDetail({required this.id, required this.name});
  factory ClientDetail.fromJson(Map<String, dynamic> j) => ClientDetail(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
      );
}

class ThreadSummary {
  final int id;
  final String subject;
  final ClientDetail client;
  final bool unread;
  final String lastMessage;
  final String lastMessageTime;
  final String lastMessageSender;
  final String lastMessageSenderCompany;

  ThreadSummary({
    required this.id,
    required this.subject,
    required this.client,
    required this.unread,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.lastMessageSender,
    required this.lastMessageSenderCompany,
  });

  factory ThreadSummary.fromJson(Map<String, dynamic> j) {
    return ThreadSummary(
      id: j['id'] as int,
      subject: j['subject'] as String? ?? '',
      client: ClientDetail.fromJson(j['client'] as Map<String, dynamic>),
      // SAFE bool cast: if null → false
      unread: (j['unread'] as bool?) ?? false,
      lastMessage: j['lastMessage'] as String? ?? '',
      lastMessageTime: j['lastMessageTime'] as String? ?? '',
      lastMessageSender: j['lastMessageSender'] as String? ?? '',
      lastMessageSenderCompany: j['lastMessageSenderCompany'] as String? ?? '',
    );
  }
}

class ThreadsResponse {
  final List<ThreadSummary> threads;
  final int currentPage;
  final int totalPages;
  final int unreadMessageCount;

  ThreadsResponse({
    required this.threads,
    required this.currentPage,
    required this.totalPages,
    required this.unreadMessageCount,
  });

  factory ThreadsResponse.fromJson(Map<String, dynamic> j) {
    return ThreadsResponse(
      threads: (j['threads'] as List<dynamic>? ?? [])
          .map((e) => ThreadSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentPage: j['currentPage'] as int? ?? 1,
      totalPages: j['totalPages'] as int? ?? 1,
      unreadMessageCount: j['unreadMessageCount'] as int? ?? 0,
    );
  }
}
