import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_app/pages/company_data/companydata_details_model.dart';
import 'package:my_app/pages/company_data/companydata_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyDataApi {
  static const _baseUrl = 'https://api.adm-dev.app/api/app/v1/entities';

  /// Fetch the list of clients (entities) associated with the current user.
  static Future<EntitiesResponse> fetchClients() async {
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
      throw Exception('Failed to load entities (${resp.statusCode})');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    return EntitiesResponse.fromJson(json);
  }

  static Future<ClientDetails> fetchClientDetails(int clientId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    final uri = Uri.parse('$_baseUrl/$clientId');
    final resp = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (resp.statusCode != 200) {
      throw Exception(
          'Unable to load client details (${resp.statusCode}): ${resp.body}');
    }
    final json = jsonDecode(resp.body) as Map<String, dynamic>;
    // our controller returns { clientIds: [...], clients: [ {...} ] }
    final clients =
        (json['clients'] as List<dynamic>).cast<Map<String, dynamic>>();
    if (clients.isEmpty) {
      throw Exception('No details returned for client $clientId');
    }
    return ClientDetails.fromJson(clients.first);
  }
}
