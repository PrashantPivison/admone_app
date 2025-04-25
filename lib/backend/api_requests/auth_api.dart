import 'dart:convert';
import 'package:http/http.dart' as http;

/// Wrapper for all authentication-related HTTP calls
class AuthApi {
  /// Base URL for your auth endpoints
  static const String _baseUrl = 'https://api.adm-dev.app/api/app/v1/auth';

  /// Performs email/password login
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? ipAddress,
    String? deviceInfo,
  }) async {
    final url = Uri.parse('$_baseUrl/login');
    final body = jsonEncode({
      'email': email,
      'password': password,
      'ipAddress': ipAddress ?? '',
      'deviceInfo': deviceInfo ?? '',
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return _processResponse(response);
  }

  /// Requests a one-time OTP to be sent to [email]
  static Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    final url = Uri.parse('$_baseUrl/loginOtp');
    final body = jsonEncode({'email': email});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return _processResponse(response);
  }

  static Future<Map<String, dynamic>> verifyOtp({
    required int userId,
    required String otp,
  }) async {
    final url = Uri.parse('$_baseUrl/verifyOtp');
    final body = jsonEncode({
      'userId': userId,
      'otp': otp,
      'ipAddress': '0.0.0.0', // dummy IP hardcoded
      'deviceInfo': 'FlutterApp',
    });

    // --- DEBUG: log request ---
    print('🔑 verifyOtp → POST $url');
    print('   Request body: $body');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // --- DEBUG: log response ---
    print('🔑 verifyOtp ← [${response.statusCode}] ${response.body}');

    return _processResponse(response);
  }

  /// NEW: Forgot password endpoint - returns a redirect URL
  static Future<void> forgotPassword({required String email}) async {
    final url = Uri.parse('$_baseUrl/forgotPassword');
    final body = jsonEncode({'email': email});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send reset link');
    }

    // Just parse and return nothing, success is enough
    _processResponse(response);
  }

  /// Common response processor - throws on error, returns JSON on success
  static Map<String, dynamic> _processResponse(http.Response response) {
    final data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return data as Map<String, dynamic>;
    }

    // Extract error message
    final error = data['error'];
    if (error is Map<String, dynamic> && error.containsKey('message')) {
      throw Exception(error['message']);
    } else if (error is String) {
      throw Exception(error);
    }

    throw Exception('Unknown error (status ${response.statusCode})');
  }
}
