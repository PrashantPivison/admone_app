// lib/backend/api_requests/chat_api.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/chats';

  /// Fetches chat threads. `clientIds` can be null to auto-load user’s clients.
  /// `searchKeyword`, `page`, `pageSize` are optional.
  static Future<Map<String, dynamic>> getThreads({
    List<int>? clientIds,
    String? searchKeyword,
    int page = 1,
    int pageSize = 10,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse(_baseUrl);

    final body = <String, dynamic>{
      'page': page,
      'pageSize': pageSize,
    };
    if (clientIds != null) body['clientIds'] = clientIds;
    if (searchKeyword != null && searchKeyword.isNotEmpty) {
      body['searchKeyword'] = searchKeyword;
    }

    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    // 👇 Update: Handle both 200 with data and empty results
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      // 👇 Improved: Include response body in the exception for better debugging
      throw Exception(
          'Failed to load chat threads (${response.statusCode}): ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getThreadMessages(int threadId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/$threadId/getChats');

    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load messages (${response.statusCode})');
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<void> sendNewMessage({
    required int threadId,
    required String messageBody,
    List<int>? files, // file IDs if any
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/$threadId/sendNewMessage');

    final body = <String, dynamic>{'messageBody': messageBody};
    if (files != null && files.isNotEmpty) {
      body['files'] = files;
    }

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (resp.statusCode != 201) {
      throw Exception(
          'Failed to send message (${resp.statusCode}): ${resp.body}');
    }
    // no need to return data; we'll re-fetch thread details
  }

  /// Upload the file to your temporary disk location
  static Future<Map<String, dynamic>> uploadFile({
    required String filePath,
    required int clientId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/File_upload');

    final req = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['clientId'] = clientId.toString()
      ..files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamed = await req.send();
    final resp = await http.Response.fromStream(streamed);
    if (resp.statusCode != 200) {
      throw Exception('Upload failed (${resp.statusCode}): ${resp.body}');
    }
    return jsonDecode(resp.body) as Map<String, dynamic>;
  }

  /// Move the uploaded file into DB entries
  static Future<List<dynamic>> saveFiles({
    required int clientId,
    required List<Map<String, dynamic>>
        files, // expect [{"originalFileName":..,"uniqueFileName":..}, ...]
    int? folderId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/save_file');

    final body = <String, dynamic>{
      'clientId': clientId,
      'files': files,
    };
    if (folderId != null) {
      body['folder_id'] = folderId;
    }

    final resp = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    if (resp.statusCode != 200) {
      throw Exception('Save files failed (${resp.statusCode}): ${resp.body}');
    }
    final j = jsonDecode(resp.body);
    return j['dbEntries'] as List<dynamic>;
  }
}
