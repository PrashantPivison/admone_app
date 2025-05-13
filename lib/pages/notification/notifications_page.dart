//
//
// import 'package:flutter/material.dart';
// import 'package:my_app/backend/api_requests/notification_api.dart';
// import '../../config/theme.dart';
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
//       appBar: PreferredSize(
//         preferredSize: const Size.fromHeight(80),
//         child: AppBar(
//           elevation: 0,
//           backgroundColor: Theme.of(context).colorScheme.primary,
//           automaticallyImplyLeading: false,
//           flexibleSpace: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.arrow_back,
//                         color: Colors.white, size: 24),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                   const SizedBox(width: 4),
//                   Text(
//                     'Notifications',
//                     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontFamily: 'Poppins',
//                         ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : _error != null
//               ? Center(child: Text("Error: $_error"))
//               : ListView.builder(
//                   padding: const EdgeInsets.symmetric(vertical: 10),
//                   itemCount: _notifications.length,
//                   itemBuilder: (ctx, i) {
//                     final n = _notifications[i];
//                     final isUnread = n['unread'] != false;
//                     final combinedTitle =
//                         '${n['title'] ?? ''} – ‘${_stripHtml(n['message'] ?? '')}’';
//                     final message = n['message'] ?? "";
//                     final senderName = n['senderName'] ?? '';
//                     final timeAgo = n['timeAgo'] ?? '';
//
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 15, vertical: 5),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10),
//                           border: Border.all(
//                               width: 1.0, color: const Color(0xFFDDDDDD)),
//                         ),
//                         child: ListTile(
//                           horizontalTitleGap: 1,
//                           contentPadding:
//                               const EdgeInsets.fromLTRB(15, 0, 15, 0),
//                           leading: isUnread
//                               ? const Padding(
//                                   padding: EdgeInsets.only(bottom: 10),
//                                   child: Icon(Icons.circle,
//                                       size: 10, color: Color(0xFF4179C5)),
//                                 )
//                               : const SizedBox(width: 16),
//                           title: Text(
//                             combinedTitle,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .labelMedium
//                                 ?.copyWith(
//                                   fontFamily: 'Inter',
//                                   color: isUnread
//                                       ? const Color(0xFF4179C5)
//                                       : Colors.black,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                           ),
//                           subtitle: Row(
//                             children: [
//                               SizedBox(
//                                 width: 150,
//                                 child: Text(
//                                   'From $senderName',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall
//                                       ?.copyWith(
//                                         fontFamily: 'Inter',
//                                         color: Colors.grey,
//                                       ),
//                                 ),
//                               ),
//                               const SizedBox(width: 10),
//                               Text('|',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .labelSmall
//                                       ?.copyWith(
//                                         fontFamily: 'Inter',
//                                         color: Colors.grey,
//                                       )),
//                               const SizedBox(width: 10),
//                               Text(
//                                 timeAgo,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .labelSmall
//                                     ?.copyWith(
//                                       fontFamily: 'Inter',
//                                       color: Colors.grey,
//                                     ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
//
//   String _stripHtml(String htmlText) {
//     return htmlText
//         .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
//         .replaceAll('\n', ' ')
//         .trim();
//   }
// }

import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/notification_api.dart';
import 'package:my_app/pages/chats/chat_details.dart';
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
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 0,
        title: Text(
          'Notifications',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      // appBar: AppBar(
      //   title: Text(
      //     'Notifications',
      //     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //       fontFamily: 'Poppins',
      //     ),
      //   ),
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      // ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  itemCount: _notifications.length,
                  itemBuilder: (ctx, i) {
                    final n = _notifications[i];
                    final isUnread = n['unread'] == null;
                    final title = n['title'] ?? '';
                    final message = _stripHtml(n['message'] ?? '');
                    final senderName = n['senderName'] ?? '';
                    final timeAgo = n['timeAgo'] ?? '';
                    final model = n['model'];
                    final modelId = n['model_id'];
                    final notificationId = n['id'];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
                      child: GestureDetector(
                        onTap: () async {
                          try {
                            // 1. Mark notification as read
                            await NotificationApi.markNotificationRead(
                                notificationId: notificationId);

                            // 2. Navigate if it's a ChatThread
                            if (model == 'ChatThread' && modelId != null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ChatDetailScreen(
                                  threadId: modelId,
                                  threadSubject:
                                      message.isNotEmpty ? message : title,
                                  clientName: senderName,
                                ),
                              ));
                            } else {
                              // TODO: Add File redirection logic later
                              debugPrint(
                                  'Clicked file notification. No action for now.');
                            }

                            // 3. Optionally refresh state to update UI
                            _fetchNotifications();
                          } catch (e) {
                            debugPrint('Error updating notification: $e');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                width: 1.0, color: const Color(0xFFDDDDDD)),
                          ),
                          child: ListTile(
                            horizontalTitleGap: 0,
                            contentPadding:
                                const EdgeInsets.fromLTRB(12, 0, 15, 0),
                            leading: isUnread
                                ? Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    width: 16,
                                    alignment: Alignment.centerLeft,
                                    child: const Icon(Icons.circle,
                                        size: 10, color: Color(0xFF4179C5)),
                                  )
                                : const SizedBox(width: 18),
                            title: Text(
                              '$title – ‘$message’',
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
                                Flexible(
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
