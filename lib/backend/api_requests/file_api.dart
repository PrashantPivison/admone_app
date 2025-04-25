// lib/backend/api_requests/file_api.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FileApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/files';

  static Future<Map<String, dynamic>> getFiles({
    int? clientId,
    int? folderId,
    String? search,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    // Build request
    final uri = Uri.parse(_baseUrl);
    final bodyMap = <String, dynamic>{};
    if (clientId != null) bodyMap['client_id'] = clientId;
    if (folderId != null) bodyMap['folder_id'] = folderId;
    if (search != null && search.isNotEmpty) bodyMap['search'] = search;
    final bodyJson = jsonEncode(bodyMap);

    // Debug logs
    print('➡️ FileApi.getFiles → POST $uri');
    print('   Authorization: Bearer $token');
    print('   Request body: $bodyJson');

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: bodyJson,
      );

      // More debug
      print('⬅️ Response status: ${response.statusCode}');
      print('⬅️ Response body: ${response.body}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load files (status ${response.statusCode})');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e, stack) {
      // Catch & rethrow so you get the full stack in your logs
      print('🔥 FileApi.getFiles error: $e');
      print(stack);
      rethrow;
    }
  }

  static Future<Uint8List> previewFile(int fileId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/$fileId/previewFile');

    print('➡️ FileApi.previewFile → GET $uri');

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    print('⬅️ Preview status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Preview failed: ${response.statusCode}');
    }
  }
}
