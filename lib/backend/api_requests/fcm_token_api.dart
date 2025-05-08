import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FcmTokenApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/Fcm_token';

  static Future<void> saveFcmToken({
    required int userId,
    required String fcmToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'user_id': userId,
        'fcm_token': fcmToken,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save FCM token: ${response.body}');
    }
  }
}
