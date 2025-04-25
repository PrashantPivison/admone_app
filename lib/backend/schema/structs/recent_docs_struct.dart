// lib/backend/schema/recent_docs_struct.dart

/// Represents a single document in "Recent Documents".
class RecentDocument {
  final String filename;
  final int daysAgo;

  RecentDocument({
    required this.filename,
    required this.daysAgo,
  });
}
