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
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppState>(context, listen: false);
    _myUserId = appState.userData?['user']?['id'] as int? ?? -1;
    _loadDetails();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
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
      _scrollToBottom();
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
          color: isMe ? CustomColors.chatsGreen : CustomColors.chatsGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (clean.isNotEmpty) Text(clean, style: chatsMessage),
            for (var f in m.files) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Image.asset('images/pdf.png', width: 20, height: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(f.fileName, style: chatsMessage),
                  ),
                ],
              )
            ],
            const SizedBox(height: 5),
            Text(
              m.messageTimeDate,
              style: chatsMessage.copyWith(
                  color: const Color(0xFFB8CBBD), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onError,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 80,
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              Container(color: Theme.of(context).colorScheme.primary),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
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
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                ),
                          ),
                        ),
                      ],
                    ),
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
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis,
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
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder<ChatDetails>(
                  future: _futureDetails,
                  builder: (ctx, s) {
                    if (s.connectionState != ConnectionState.done) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (s.hasError) {
                      return const Center(
                          child: Text('Failed to load messages'));
                    }
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottom());

                    return ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: s.data!.messages.length,
                      itemBuilder: (_, i) => _buildMessage(s.data!.messages[i]),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: CustomColors.chatsBorder, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: CustomColors.chatsGrey,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _msgCtrl,
                            decoration: const InputDecoration(
                              hintText: "Type your message here...",
                              hintStyle: TextStyle(
                                color: Color(0xFFAEAEAE),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _attachFile,
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.attach_file,
                                    size: 16, color: Colors.black),
                                const SizedBox(width: 4),
                                Text('Attach',
                                    style:
                                        btnText.copyWith(color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: _sending ? null : _sendMessage,
                          child: Container(
                            height: 30,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: _sending
                                  ? const SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.arrow_forward,
                                            size: 16, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text('Send',
                                            style: btnText.copyWith(
                                                color: Colors.white)),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_pickedPaths.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Selected: ${_pickedPaths.first.split('/').last}',
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
