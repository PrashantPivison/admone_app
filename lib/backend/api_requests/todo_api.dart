import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TodoApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/todo';

  /// Fetch the current user’s to-do tasks.
  static Future<Map<String, dynamic>> fetchTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse(_baseUrl);
    final resp = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode != 200) {
      throw Exception('Failed to load todos (${resp.statusCode})');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  // Mark a task as done
  static Future<void> updateTask({
    required int threadId,
    required int taskIndex,
  }) async {
    print(
        '[TodoApi] updateTask(threadId=$threadId, taskIndex=$taskIndex)'); // DEBUG
    final url = '$_baseUrl/$threadId/updateTask';
    print('[TodoApi] PATCH → $url'); // DEBUG
    print('threadId → $threadId'); // DEBUG

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final resp = await http.patch(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'taskIndex': taskIndex}),
    );
    print('[TodoApi] Response ${resp.statusCode}: ${resp.body}'); // DEBUG
    if (resp.statusCode != 200) {
      throw Exception('Failed to update task (${resp.statusCode})');
    }
  }
}
