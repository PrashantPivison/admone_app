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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Text('Notifications',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                          fontFamily: 'Poppins',
                          color: Theme.of(context).colorScheme.onSecondary,
                        )),
                  ],
                ),
              ],
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
                contentPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                leading: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(
                    Icons.circle,
                    size: 10
                    ,
                    color: Color(0xFF4179C5), // 0xFF for full opacity + hex color
                  ),
                ),
                title: Text(n['title'] ?? '',
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(
                      fontFamily: 'Inter',
                        color: Color(0xFF4179C5),
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis
                    )),
                subtitle: Row(
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        n['message'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontFamily: 'Inter',
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      '|',  // This is the vertical pipe character
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      n['timeAgo'] ?? '',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontFamily: 'Inter',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                // trailing: Text(
                //   n['timeAgo'] ?? '',
                //   style: Theme.of(context)
                //       .textTheme
                //       .labelSmall
                //       ?.copyWith(
                //     fontFamily: 'Inter',
                //     color: Colors.grey,
                //   ),
                // ),
              ),
            ),
          );
        },
      ),
    );
  }
}