// // lib/ui/dashboard.dart
//
import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/chat_api.dart';
import 'package:my_app/pages/chats/chat_details.dart';
import 'package:my_app/pages/chats/chat_model.dart';
import 'package:my_app/pages/documents/documents.dart';
import '../../config/theme.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatState();
}

class _ChatState extends State<Chats> {
  late Future<ThreadsResponse> _futureThreads;
  final TextEditingController _searchController = TextEditingController();
  int _page = 1;

  @override
  void initState() {
    super.initState();
    _loadThreads();
  }

  void _loadThreads() {
    _futureThreads = ChatApi.getThreads(
      searchKeyword: _searchController.text.trim().isEmpty
          ? null
          : _searchController.text.trim(),
      page: _page,
      pageSize: 10,
    ).then((json) => ThreadsResponse.fromJson(json));
    setState(() {});
  }

  Widget _buildListItem(BuildContext context, {required ThreadSummary t}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
              threadId: t.id,
              threadSubject: t.subject,
              clientName: t.client.name),
        ));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDDDDDD)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.message_outlined,
                size: 25,
                color: t.unread ? Colors.green : Colors.grey,
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.subject,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontFamily: 'Inter',
                            color: CustomColors.text,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${t.lastMessageSenderCompany}: ${t.lastMessage}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            fontFamily: 'Inter',
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                t.lastMessageTime,
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 140,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Stack(
          children: [
            Container(color: Theme.of(context).colorScheme.primary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // GestureDetector(
                      //   onTap: () => Navigator.pushAndRemoveUntil(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const FilesScreen()),
                      //         (route) => false,
                      //   ),
                      //   child: const Icon(
                      //     Icons.arrow_back,
                      //     color: Colors.white,
                      //     size: 20,
                      //   ),
                      // ),
                      const SizedBox(width: 10),
                      Text(
                        'Messages',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.add_circle_outline,
                                size: 14, color: Colors.white),
                            SizedBox(width: 6),
                            Text(
                              'New Message',
                              style:
                              TextStyle(color: Colors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // SEARCH FIELD
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      hintText: 'Search messages...',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                    ),
                    style: const TextStyle(fontSize: 12),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) {
                      _page = 1;
                      _loadThreads();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<ThreadsResponse>(
        future: _futureThreads,
        builder: (ctx, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final resp = snap.data!;
          if (resp.threads.isEmpty) {
            return const Center(child: Text('No conversations'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: resp.threads
                    .map((t) => Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 5),
                  child: _buildListItem(context, t: t),
                ))
                    .toList(),
              ),
            ),
          );
        },
      ),
    ), );
  }
}



