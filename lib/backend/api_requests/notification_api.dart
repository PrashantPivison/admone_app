import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/notification';

  static Future<List<Map<String, dynamic>>> getNotifications(
      {bool fetchAll = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final uri = Uri.parse("$_baseUrl?all=$fetchAll");
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to load notifications');
    }

    final data = jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(data['notifications']);
  }

  static Future<void> markNotificationRead({
    required int notificationId,
    bool markAll = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    print("notificationId $notificationId");
    final response = await http.post(
      Uri.parse('https://api.adm-dev.app/api/app/v1/notification/read'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'notification_id': notificationId,
        'mark_all': markAll,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification: ${response.body}');
    }
  }
}
