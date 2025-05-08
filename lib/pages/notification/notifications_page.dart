import 'package:flutter/material.dart';
import 'package:my_app/backend/api_requests/notification_api.dart';

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
      appBar: AppBar(title: const Text("Notifications")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : ListView.builder(
                  itemCount: _notifications.length,
                  itemBuilder: (ctx, i) {
                    final n = _notifications[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(n['title'] ?? ''),
                        subtitle: Text(n['message'] ?? ''),
                        trailing: Text(
                          n['timeAgo'] ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
