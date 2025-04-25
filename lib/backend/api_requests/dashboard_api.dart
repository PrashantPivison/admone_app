import 'dart:convert';
import 'package:http/http.dart' as http;

class DashboardApi {
  static const String _baseUrl = 'https://api.adm-dev.app/api/app/v1/dashboard';

  static Future<Map<String, dynamic>> getDashboardStats(String token) async {
    final url = Uri.parse('$_baseUrl/getDashboardStats');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Failed to load dashboard stats');
    }
  }
}
