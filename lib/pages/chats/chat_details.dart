import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:my_app/app_state.dart';
import 'package:my_app/backend/api_requests/chat_api.dart';
import 'package:my_app/pages/chats/chat_details_model.dart';
import '../../config/theme.dart';

class ChatDetailScreen extends StatefulWidget {
  final int threadId;
  final String threadSubject;
  final String clientName;

  const ChatDetailScreen({
    Key? key,
    required this.threadId,
    required this.threadSubject,
    required this.clientName,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late Future<ChatDetails> _futureDetails;
  final _msgCtrl = TextEditingController();
  late int _myUserId;
  bool _sending = false;
  List<String> _pickedPaths = [];

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _myUserId = appState.userData?['user']?['id'] as int? ?? -1;
    _loadDetails();
  }

  void _loadDetails() {
    _futureDetails = ChatApi.getThreadMessages(widget.threadId)
        .then((j) => ChatDetails.fromJson(j));
    setState(() {});
  }

  Future<void> _attachFile() async {
    final res = await FilePicker.platform.pickFiles();
    if (res == null) return;
    setState(() => _pickedPaths = [res.files.single.path!]);
  }

  Future<void> _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);

    try {
      // fetch clientId from loaded details
      final details = await _futureDetails;
      final cid = details.clientId;

      List<int> fileIds = [];
      if (_pickedPaths.isNotEmpty) {
        // 1) upload
        final up = await ChatApi.uploadFile(
          filePath: _pickedPaths.first,
          clientId: cid,
        );
        // 2) save to DB
        final saved = await ChatApi.saveFiles(
          clientId: cid,
          files: [
            {
              'originalFileName': up['originalFileName'],
              'uniqueFileName': up['uniqueFileName'],
            }
          ],
        );
        fileIds = saved.map((e) => e['id'] as int).toList();
      }

      // 3) send message (with file IDs if any)
      await ChatApi.sendNewMessage(
        threadId: widget.threadId,
        messageBody: text,
        files: fileIds.isEmpty ? null : fileIds,
      );

      // clear & refresh
      _msgCtrl.clear();
      setState(() => _pickedPaths.clear());
      _loadDetails();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Send failed: $e')),
      );
    } finally {
      setState(() => _sending = false);
    }
  }

  Widget _buildMessage(ChatMessageDetail m) {
    final isMe =
        m.senderType == 'clientportal_user' && m.senderId == '$_myUserId';
    final clean = m.body.replaceAll(RegExp(r'<[^>]*>'), '');
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? CustomColors.chatsgreen : CustomColors.chatsgrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (clean.isNotEmpty) Text(clean, style: chatsmessage),
            for (var f in m.files) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.insert_drive_file, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(f.fileName, style: chatsmessage)),
                ],
              )
            ],
            const SizedBox(height: 5),
            Text(m.messageTimeDate,
                style: chatsmessage.copyWith(
                    color: const Color(0xFFB8CBBD), fontSize: 11)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onError,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 75,
        elevation: 0,
        flexibleSpace: Stack(children: [
          Container(color: Theme.of(context).colorScheme.primary),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.threadSubject,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                    ),
                  ),
                ]),
                const SizedBox(height: 5),
                FutureBuilder<ChatDetails>(
                  future: _futureDetails,
                  builder: (ctx, s) {
                    if (s.hasData && s.data!.messages.isNotEmpty) {
                      final last = s.data!.messages.last.messageTimeDate;
                      return Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          'From ${widget.clientName}  |  Last Message $last',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                fontFamily: 'Poppins',
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(children: [
          Expanded(
            child: FutureBuilder<ChatDetails>(
              future: _futureDetails,
              builder: (ctx, s) {
                if (s.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (s.hasError) {
                  return const Center(child: Text('Failed to load messages'));
                }
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: s.data!.messages.length,
                  itemBuilder: (_, i) => _buildMessage(s.data!.messages[i]),
                );
              },
            ),
          ),

          // bottom input + attach + send
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: CustomColors.chatsgrey,
              border: Border.all(color: CustomColors.chatsborder, width: 1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Row(children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: "Type your message here...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: _attachFile,
                ),
              ]),
              if (_pickedPaths.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Selected: ${_pickedPaths.first.split('/').last}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  onPressed: _sending ? null : _sendMessage,
                  child: _sending
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Send'),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String threadId;
//   final String threadSubject;
//   final String clientName;
//
//   const ChatScreen({
//     super.key,
//     required this.threadId,
//     required this.threadSubject,
//     required this.clientName,
//   });
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
//
// class _ChatScreenState extends State<ChatScreen> {
//   final List<Map<String, dynamic>> messages = [];
//   final TextEditingController _messageController = TextEditingController();
//
//   void _sendMessage() {
//     if (_messageController.text.trim().isEmpty) return;
//
//     setState(() {
//       messages.insert(0, {
//         'text': _messageController.text.trim(),
//         'time': 'Just now',
//         'isMe': true,
//         'type': 'text',
//       });
//     });
//
//     _messageController.clear();
//   }
//
//   void _attachFile() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//
//     if (result != null && result.files.single.path != null) {
//       String fileName = result.files.single.name;
//
//       setState(() {
//         messages.insert(0, {
//           'text': fileName,
//           'time': 'Just now',
//           'isMe': true,
//           'type': 'file',
//         });
//       });
//     }
//   }
//
//   Widget _buildMessageBubble(Map<String, dynamic> message) {
//     bool isMe = message['isMe'] ?? false;
//     bool isFile = message['type'] == 'file';
//
//     return Align(
//       alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
//         padding: const EdgeInsets.all(10.0),
//         decoration: BoxDecoration(
//           color: isMe ? Colors.blueAccent : Colors.grey[300],
//           borderRadius: BorderRadius.circular(12.0),
//         ),
//         child: isFile
//             ? Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.attach_file, color: Colors.white),
//             const SizedBox(width: 8),
//             Text(
//               message['text'],
//               style: const TextStyle(color: Colors.white),
//             ),
//           ],
//         )
//             : Text(
//           message['text'],
//           style: const TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat Screen'),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               reverse: true,
//               itemCount: messages.length,
//               itemBuilder: (context, index) {
//                 return _buildMessageBubble(messages[index]);
//               },
//             ),
//           ),
//           const Divider(height: 1),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             color: Colors.white,
//             child: Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.attach_file),
//                   onPressed: _attachFile,
//                 ),
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration:
//                     const InputDecoration.collapsed(hintText: 'Message...'),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
