// lib/models/document_model.dart

import 'package:my_app/backend/api_requests/file_api.dart';

/// “Flat” client info from your API
class ClientDetail {
  final int id;
  final String name;

  ClientDetail({
    required this.id,
    required this.name,
  });

  factory ClientDetail.fromJson(Map<String, dynamic> j) {
    String safeString(Object? v) => v == null ? '' : v.toString();
    int safeInt(Object? v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return ClientDetail(
      id: safeInt(j['id']),
      name: safeString(j['name']),
    );
  }
}

class Breadcrumb {
  final int id;
  final int? parent;
  final String name;
  final int clientId;

  Breadcrumb({
    required this.id,
    required this.parent,
    required this.name,
    required this.clientId,
  });

  factory Breadcrumb.fromJson(Map<String, dynamic> j) {
    String safeString(Object? v) => v == null ? '' : v.toString();
    int safeInt(Object? v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return Breadcrumb(
      id: safeInt(j['id']),
      parent: j['parent'] == null ? null : safeInt(j['parent']),
      name: safeString(j['name']),
      clientId: safeInt(j['client_id']),
    );
  }
}

class FileItem {
  final int id;
  final String fileName;
  final String formattedSize;
  final String createdAt;
  final String clientName;
  final String uploadedBy;

  FileItem({
    required this.id,
    required this.fileName,
    required this.formattedSize,
    required this.createdAt,
    required this.clientName,
    required this.uploadedBy,
  });

  factory FileItem.fromJson(Map<String, dynamic> j) {
    String safeString(Object? v) => v == null ? '' : v.toString();
    int safeInt(Object? v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return FileItem(
      id: safeInt(j['id']),
      fileName: safeString(j['file_name']),
      formattedSize: safeString(j['formatted_file_size']),
      createdAt: safeString(j['created_at']),
      clientName: safeString(j['client_name']),
      uploadedBy: safeString(j['uploaded_by_name']),
    );
  }
}

class FolderItem {
  final int id;
  final String name;
  final String createdAt;
  final String clientName;
  final String createdBy;

  FolderItem({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.clientName,
    required this.createdBy,
  });

  factory FolderItem.fromJson(Map<String, dynamic> j) {
    String safeString(Object? v) => v == null ? '' : v.toString();
    int safeInt(Object? v) {
      if (v is int) return v;
      if (v is num) return v.toInt();
      return int.tryParse(v?.toString() ?? '') ?? 0;
    }

    return FolderItem(
      id: safeInt(j['id']),
      name: safeString(j['folder_name']),
      createdAt: safeString(j['created_at']),
      clientName: safeString(j['client_name']),
      createdBy: safeString(j['created_by_name']),
    );
  }
}

class FilesFoldersResponse {
  final List<ClientDetail> clientDetails;
  final List<Breadcrumb> breadcrumbs;
  final List<FolderItem> folders;
  final List<FileItem> files;

  FilesFoldersResponse({
    required this.clientDetails,
    required this.breadcrumbs,
    required this.folders,
    required this.files,
  });

  factory FilesFoldersResponse.fromJson(Map<String, dynamic> j) {
    return FilesFoldersResponse(
      clientDetails: (j['clientDetails'] as List<dynamic>?)
              ?.map((e) => ClientDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      breadcrumbs: (j['breadcrumbs'] as List<dynamic>?)
              ?.map((e) => Breadcrumb.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      folders: (j['folders'] as List<dynamic>?)
              ?.map((e) => FolderItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      files: (j['files'] as List<dynamic>?)
              ?.map((e) => FileItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class DocumentRepository {
  Future<FilesFoldersResponse> fetch({
    int? clientId,
    int? folderId,
    String? search,
  }) async {
    final json = await FileApi.getFiles(
      clientId: clientId,
      folderId: folderId,
      search: search,
    );
    return FilesFoldersResponse.fromJson(json);
  }
}
