/// Represents a single client/entity
class ClientInfo {
  final int id;
  final String name;
  final String? businessStructure;
  final String? fullAddress;

  ClientInfo({
    required this.id,
    required this.name,
    this.businessStructure,
    this.fullAddress,
  });

  factory ClientInfo.fromJson(Map<String, dynamic> j) {
    return ClientInfo(
      id: j['id'] as int,
      name: j['name'] as String? ?? '',
      businessStructure: j['business_structure'] as String?,
      fullAddress: j['full_address'] as String?,
    );
  }
}

/// Wrapper for the entire response
class EntitiesResponse {
  final List<int> clientIds;
  final List<ClientInfo> clients;

  EntitiesResponse({
    required this.clientIds,
    required this.clients,
  });

  factory EntitiesResponse.fromJson(Map<String, dynamic> j) {
    final rawIds = (j['clientIds'] as List<dynamic>?) ?? [];
    final rawClients = (j['clients'] as List<dynamic>?) ?? [];
    return EntitiesResponse(
      clientIds: rawIds.map((e) => e as int).toList(),
      clients: rawClients
          .map((e) => ClientInfo.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
