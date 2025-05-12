// import 'package:flutter/material.dart';
// import 'package:my_app/backend/api_requests/notification_api.dart';
//
// class NotificationsPage extends StatefulWidget {
//   const NotificationsPage({Key? key}) : super(key: key);
//
//   @override
//   State<NotificationsPage> createState() => _NotificationsPageState();
// }
//
// class _NotificationsPageState extends State<NotificationsPage> {
//   List<Map<String, dynamic>> _notifications = [];
//   bool _loading = true;
//   String? _error;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchNotifications();
//   }
//
//   Future<void> _fetchNotifications() async {
//     try {
//       final data = await NotificationApi.getNotifications(fetchAll: true);
//       setState(() {
//         _notifications = data;
//         _loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _error = e.toString();
//         _loading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Notifications")),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? Center(child: Text("Error: $_error"))
//               : ListView.builder(
//                   itemCount: _notifications.length,
//                   itemBuilder: (ctx, i) {
//                     final n = _notifications[i];
//                     return Card(
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 5),
//                       child: ListTile(
//                         leading: const Icon(Icons.notifications),
//                         title: Text(n['title'] ?? ''),
//                         subtitle: Text(n['message'] ?? ''),
//                         trailing: Text(
//                           n['timeAgo'] ?? '',
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/notification_api.dart';
import '../../config/theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      final data = await NotificationApi.getNotifications(fetchAll: true);
      setState(() {
        _notifications = data;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 24),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Notifications',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemCount: _notifications.length,
                  itemBuilder: (ctx, i) {
                    final n = _notifications[i];
                    final isUnread = n['unread'] != false;
                    final combinedTitle =
                        '${n['title'] ?? ''} – ‘${_stripHtml(n['message'] ?? '')}’';
                    final message = n['message'] ?? "";
                    final senderName = n['senderName'] ?? '';
                    final timeAgo = n['timeAgo'] ?? '';

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 1.0, color: const Color(0xFFDDDDDD)),
                        ),
                        child: ListTile(
                          horizontalTitleGap: 1,
                          contentPadding:
                              const EdgeInsets.fromLTRB(15, 0, 15, 0),
                          leading: isUnread
                              ? const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Icon(Icons.circle,
                                      size: 10, color: Color(0xFF4179C5)),
                                )
                              : const SizedBox(width: 16),
                          title: Text(
                            combinedTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  fontFamily: 'Inter',
                                  color: isUnread
                                      ? const Color(0xFF4179C5)
                                      : Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  'From $senderName',
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text('|',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontFamily: 'Inter',
                                        color: Colors.grey,
                                      )),
                              const SizedBox(width: 10),
                              Text(
                                timeAgo,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      fontFamily: 'Inter',
                                      color: Colors.grey,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  String _stripHtml(String htmlText) {
    return htmlText
        .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
        .replaceAll('\n', ' ')
        .trim();
  }
}
