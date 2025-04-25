class FileDetail {
  final int id;
  final String fileName;
  final String diskName;
  final int fileSize;
  final String fileType;
  final String fileUrl;

  FileDetail({
    required this.id,
    required this.fileName,
    required this.diskName,
    required this.fileSize,
    required this.fileType,
    required this.fileUrl,
  });

  factory FileDetail.fromJson(Map<String, dynamic> j) => FileDetail(
        id: j['id'] as int,
        fileName: j['file_name'] as String? ?? '',
        diskName: j['disk_name'] as String? ?? '',
        fileSize: j['file_size'] as int? ?? 0,
        fileType: j['file_type'] as String? ?? '',
        fileUrl: j['file_url'] as String? ?? '',
      );
}

class ChatMessageDetail {
  final int id;
  final String body;
  final String createdAt;
  final String updatedAt;
  final String messageTimeDate;
  final String senderName;
  final String senderType;
  final String senderId;
  final List<FileDetail> files;

  ChatMessageDetail({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    required this.messageTimeDate,
    required this.senderName,
    required this.senderType,
    required this.senderId,
    required this.files,
  });

  factory ChatMessageDetail.fromJson(Map<String, dynamic> j) {
    final filesJson = j['files'] as List<dynamic>? ?? [];
    return ChatMessageDetail(
      id: j['id'] as int,
      body: j['body'] as String? ?? '',
      createdAt: j['created_at'] as String? ?? '',
      updatedAt: j['updated_at'] as String? ?? '',
      messageTimeDate: j['message_time_date'] as String? ?? '',
      senderName: j['senderName'] as String? ?? '',
      senderType: j['senderType'] as String? ?? '',
      senderId: j['senderid']?.toString() ?? '',
      files: filesJson
          .map((e) => FileDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChatDetails {
  final List<ChatMessageDetail> messages;
  final List<String>? tasks;
  final int clientId;
  final String subject;

  ChatDetails({
    required this.messages,
    this.tasks,
    required this.clientId,
    required this.subject,
  });

  factory ChatDetails.fromJson(Map<String, dynamic> j) {
    return ChatDetails(
      messages: (j['messages'] as List<dynamic>? ?? [])
          .map((e) => ChatMessageDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      tasks: j['tasks'] != null
          ? (j['tasks'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      clientId: j['client_id'] as int? ?? 0,
      subject: j['subject'] as String? ?? '',
    );
  }
}
