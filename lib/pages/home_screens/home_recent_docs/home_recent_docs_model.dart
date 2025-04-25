// lib/pages/home_screens/recent_docs_model.dart

import 'package:flutter/material.dart';
import 'package:my_app/backend/schema/structs/recent_docs_struct.dart';

class HomeRecentDocsModel extends ChangeNotifier {
  // Private list of documents
  List<RecentDocument> _recentDocs = [
    RecentDocument(filename: 'M-Power.png', daysAgo: 21),
  ];

  // GETTER for widgets
  List<RecentDocument> get recentDocs => _recentDocs;

  Future<void> loadDocs() async {
    await Future.delayed(const Duration(seconds: 1));
    _recentDocs.add(
      RecentDocument(filename: 'NewFile.pdf', daysAgo: 10),
    );
    notifyListeners();
  }
}
