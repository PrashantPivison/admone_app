// lib/ui/dashboard/files_screen.dart

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:my_app/pages/documents/document_model.dart';
// import 'package:my_app/pages/documents/preview_page.dart';
// import '../../config/theme.dart';
//
// /// A simple wrapper so we can treat folders & files in one list.
// class _Item {
//   final FolderItem? folder;
//   final FileItem? file;
//   bool get isFolder => folder != null;
//
//   _Item.folder(this.folder) : file = null;
//   _Item.file(this.file) : folder = null;
// }
//
// class FilesScreen extends StatefulWidget {
//   const FilesScreen({super.key});
//
//   @override
//   State<FilesScreen> createState() => _FilesScreenState();
// }
//
// class _FilesScreenState extends State<FilesScreen> {
//   int? _currentClientId;
//   int? _currentFolderId;
//   String? _currentSearch;
//
//   bool _isLoadingData = true; // initial fetch
//   bool _isLoadingMore = false; // pagination loader
//   int _currentMax = 5; // how many items to show
//   List<_Item> _allItems = [];
//   FilesFoldersResponse? _lastResponse;
//
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _load(); // first load
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//             _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore &&
//         _allItems.length > _currentMax) {
//       _loadMore();
//     }
//   }
//
//   void _loadMore() {
//     setState(() => _isLoadingMore = true);
//     // simulate delay so loader is visible
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _currentMax = min(_currentMax + 5, _allItems.length);
//         _isLoadingMore = false;
//       });
//     });
//   }
//
//   void _load() {
//     setState(() {
//       _isLoadingData = true;
//       _currentMax = 5;
//     });
//
//     DocumentRepository()
//         .fetch(
//       clientId: _currentClientId,
//       folderId: _currentFolderId,
//       search: _currentSearch,
//     )
//         .then((resp) {
//       // flatten folders + files
//       final items = <_Item>[
//         ...resp.folders.map((f) => _Item.folder(f)),
//         ...resp.files.map((f) => _Item.file(f)),
//       ];
//       setState(() {
//         _lastResponse = resp;
//         _allItems = items;
//         _isLoadingData = false;
//         _currentMax = min(5, items.length);
//       });
//     }).catchError((e) {
//       setState(() => _isLoadingData = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     });
//   }
//
//   Widget _crumb(String text, VoidCallback onTap) => InkWell(
//         onTap: onTap,
//         child: Text(text,
//             style: const TextStyle(
//               decoration: TextDecoration.underline,
//               fontWeight: FontWeight.w500,
//             )),
//       );
//
//   Widget _sep() => const Padding(
//         padding: EdgeInsets.symmetric(horizontal: 6),
//         child: Text('/', style: TextStyle(fontWeight: FontWeight.w600)),
//       );
//
//   Widget _buildBreadcrumbs() {
//     final resp = _lastResponse;
//     if (resp == null) return const SizedBox.shrink();
//
//     final crumbs = <Widget>[];
//
//     // Home
//     crumbs.add(_crumb('Home', () {
//       _currentClientId = null;
//       _currentFolderId = null;
//       _currentSearch = null;
//       _searchController.clear();
//       _load();
//     }));
//
//     // if inside a folder, show client + folder chain
//     if (resp.breadcrumbs.isNotEmpty) {
//       final rootBC = resp.breadcrumbs.first;
//       final client = resp.clientDetails.firstWhere(
//         (c) => c.id == rootBC.clientId,
//         orElse: () => ClientDetail(id: rootBC.clientId, name: ''),
//       );
//
//       crumbs.add(_sep());
//       crumbs.add(_crumb(client.name, () {
//         _currentClientId = client.id;
//         _currentFolderId = null;
//         _currentSearch = null;
//         _searchController.clear();
//         _load();
//       }));
//
//       for (final bc in resp.breadcrumbs) {
//         crumbs.add(_sep());
//         crumbs.add(_crumb(bc.name, () {
//           _currentClientId = client.id;
//           _currentFolderId = bc.id;
//           _currentSearch = null;
//           _searchController.clear();
//           _load();
//         }));
//       }
//     }
//
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Row(children: crumbs),
//     );
//   }
//
//   Widget _buildRow(
//       Widget icon, String title, String subtitle, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFDDDDDD)),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(children: [
//           icon,
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelMedium
//                         ?.copyWith(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 4),
//                 Text(subtitle,
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelSmall
//                         ?.copyWith(color: Colors.grey)),
//               ],
//             ),
//           )
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildFolderItem(FolderItem f) => _buildRow(
//         const Icon(Icons.folder, size: 24, color: Colors.orange),
//         f.name,
//         f.createdAt,
//         () {
//           _currentFolderId = f.id;
//           _load();
//         },
//       );
//
//   Widget _buildFileItem(FileItem f) {
//     final icon = f.fileName.toLowerCase().endsWith('.pdf')
//         ? Image.asset('images/pdf.png', width: 18, height: 24)
//         : Image.asset('images/jpg.png', width: 18, height: 24);
//     return _buildRow(icon, f.fileName, f.createdAt, () {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => FilePreviewPage(
//             fileId: f.id,
//             fileName: f.fileName,
//           ),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: 130,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Stack(children: [
//           Container(color: Theme.of(context).colorScheme.primary),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             child: Column(children: [
//               Row(children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back,
//                       color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 10),
//                 Text('Files',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineMedium
//                         ?.copyWith(color: Colors.white)),
//                 const Spacer(),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.error,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(children: const [
//                     Icon(Icons.add_circle_outline,
//                         size: 14, color: Colors.white),
//                     SizedBox(width: 6),
//                     Text('New File',
//                         style: TextStyle(color: Colors.white, fontSize: 11)),
//                   ]),
//                 ),
//               ]),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   contentPadding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   hintText: 'Search files or folders...',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                   prefixIcon: const Icon(Icons.search, size: 18),
//                   isDense: true,
//                 ),
//                 textInputAction: TextInputAction.search,
//                 // Trigger search on every keystroke:
//                 onChanged: (q) {
//                   _currentSearch = q.trim().isEmpty ? null : q.trim();
//                   _load();
//                 },
//                 // Also keep the Enter behavior:
//                 onSubmitted: (q) {
//                   _currentSearch = q.trim().isEmpty ? null : q.trim();
//                   _load();
//                 },
//               ),
//             ]),
//           ),
//         ]),
//       ),
//       body: SafeArea(
//         child: _isLoadingData
//             ? const Center(child: CircularProgressIndicator())
//             : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildBreadcrumbs(),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _allItems.length > _currentMax
//                           ? _currentMax + 1
//                           : _allItems.length,
//                       itemBuilder: (ctx, i) {
//                         if (i == _currentMax && _isLoadingMore) {
//                           return const Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//                         final item = _allItems[i];
//                         return item.isFolder
//                             ? _buildFolderItem(item.folder!)
//                             : _buildFileItem(item.file!);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:my_app/pages/documents/document_model.dart';
// import 'package:my_app/pages/documents/preview_page.dart';
// import '../../config/theme.dart';
//
// /// A simple wrapper so we can treat folders & files in one list.
// class _Item {
//   final FolderItem? folder;
//   final FileItem? file;
//   bool get isFolder => folder != null;
//
//   _Item.folder(this.folder) : file = null;
//   _Item.file(this.file) : folder = null;
// }
//
// class FilesScreen extends StatefulWidget {
//   const FilesScreen({super.key});
//
//   @override
//   State<FilesScreen> createState() => _FilesScreenState();
// }
//
// class _FilesScreenState extends State<FilesScreen> {
//   int? _currentClientId;
//   int? _currentFolderId;
//   String? _currentSearch;
//
//   bool _isLoadingData = true; // initial fetch
//   bool _isLoadingMore = false; // pagination loader
//   int _currentMax = 5; // how many items to show
//   List<_Item> _allItems = [];
//   FilesFoldersResponse? _lastResponse;
//
//   final TextEditingController _searchController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _scrollController.addListener(_onScroll);
//     _load(); // first load
//   }
//
//   @override
//   void dispose() {
//     _scrollController.removeListener(_onScroll);
//     _scrollController.dispose();
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 100 &&
//         !_isLoadingMore &&
//         _allItems.length > _currentMax) {
//       _loadMore();
//     }
//   }
//
//   void _loadMore() {
//     setState(() => _isLoadingMore = true);
//     // simulate delay so loader is visible
//     Future.delayed(const Duration(milliseconds: 500), () {
//       setState(() {
//         _currentMax = min(_currentMax + 5, _allItems.length);
//         _isLoadingMore = false;
//       });
//     });
//   }
//
//   void _load() {
//     setState(() {
//       _isLoadingData = true;
//       _currentMax = 5;
//     });
//
//     DocumentRepository()
//         .fetch(
//       clientId: _currentClientId,
//       folderId: _currentFolderId,
//       search: _currentSearch,
//     )
//         .then((resp) {
//       // flatten folders + files
//       final items = <_Item>[
//         ...resp.folders.map((f) => _Item.folder(f)),
//         ...resp.files.map((f) => _Item.file(f)),
//       ];
//       setState(() {
//         _lastResponse = resp;
//         _allItems = items;
//         _isLoadingData = false;
//         _currentMax = min(5, items.length);
//       });
//     }).catchError((e) {
//       setState(() => _isLoadingData = false);
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text('Error: $e')));
//     });
//   }
//
//   Widget _crumb(String text, VoidCallback onTap) => InkWell(
//     onTap: onTap,
//     child: Text(text,
//         style: const TextStyle(
//           decoration: TextDecoration.underline,
//           fontWeight: FontWeight.w600,
//           fontSize: 14,
//           fontFamily: "inter",
//
//         )),
//   );
//
//   Widget _sep() => const Padding(
//     padding: EdgeInsets.symmetric(horizontal: 6),
//     child: Text('/', style: TextStyle(fontWeight: FontWeight.w600)),
//   );
//
//   Widget _buildBreadcrumbs() {
//     final resp = _lastResponse;
//     if (resp == null) return const SizedBox.shrink();
//
//     final crumbs = <Widget>[];
//
//     // Home
//     crumbs.add(_crumb('Home', () {
//       _currentClientId = null;
//       _currentFolderId = null;
//       _currentSearch = null;
//       _searchController.clear();
//       _load();
//     }));
//
//     // if inside a folder, show client + folder chain
//     if (resp.breadcrumbs.isNotEmpty) {
//       final rootBC = resp.breadcrumbs.first;
//       final client = resp.clientDetails.firstWhere(
//             (c) => c.id == rootBC.clientId,
//         orElse: () => ClientDetail(id: rootBC.clientId, name: ''),
//       );
//
//       crumbs.add(_sep());
//       crumbs.add(_crumb(client.name, () {
//         _currentClientId = client.id;
//         _currentFolderId = null;
//         _currentSearch = null;
//         _searchController.clear();
//         _load();
//       } ) ) ;
//
//           for (final bc in resp.breadcrumbs) {
//         crumbs.add(_sep());
//         crumbs.add(_crumb(bc.name, () {
//           _currentClientId = client.id;
//           _currentFolderId = bc.id;
//           _currentSearch = null;
//           _searchController.clear();
//           _load();
//         }) );
//           }
//           }
//
//           return SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//           child: Row(children: crumbs),
//         );
//       }
//
//   Widget _buildRow(
//       Widget icon, String title, String subtitle, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 10),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFDDDDDD)),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(children: [
//           icon,
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title,
//                     overflow: TextOverflow.ellipsis,
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelMedium
//                         ?.copyWith(fontWeight: FontWeight.w600)),
//                 const SizedBox(height: 4),
//                 Text(subtitle,
//                     style: Theme.of(context)
//                         .textTheme
//                         .labelSmall
//                         ?.copyWith(color: Colors.grey)),
//               ],
//             ),
//           )
//         ]),
//       ),
//     );
//   }
//
//   Widget _buildFolderItem(FolderItem f) => _buildRow(
//     const Icon(Icons.folder, size: 24, color: Colors.orange),
//     f.name,
//     f.createdAt,
//         () {
//       _currentFolderId = f.id;
//       _load();
//     },
//   );
//
//   Widget _buildFileItem(FileItem f) {
//     final icon = f.fileName.toLowerCase().endsWith('.pdf')
//         ? Image.asset('images/pdf.png', width: 18, height: 24)
//         : Image.asset('images/jpg.png', width: 18, height: 24);
//     return _buildRow(icon, f.fileName, f.createdAt, () {
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (_) => FilePreviewPage(
//             fileId: f.id,
//             fileName: f.fileName,
//           ),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         toolbarHeight: 130,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         flexibleSpace: Stack(children: [
//           Container(color: Theme.of(context).colorScheme.primary),
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
//             child: Column(children: [
//               Row(children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back,
//                       color: Colors.white, size: 20),
//                 ),
//                 const SizedBox(width: 10),
//                 Text('Files',
//                     style: Theme.of(context)
//                         .textTheme
//                         .headlineMedium
//                         ?.copyWith(color: Colors.white)),
//                 const Spacer(),
//                 Container(
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Theme.of(context).colorScheme.error,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Row(children: const [
//                     Icon(Icons.add_circle_outline,
//                         size: 14, color: Colors.white),
//                     SizedBox(width: 6),
//                     Text('New File',
//                         style: TextStyle(color: Colors.white, fontSize: 11)),
//                   ]),
//                 ),
//               ]),
//               const SizedBox(height: 12),
//               TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 8, vertical: 4),
//                   hintText: 'Search messages...',
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                   prefixIcon: const Icon(Icons.search, size: 18),
//                   isDense: true,
//                 ),
//                 style: const TextStyle(fontSize: 12),
//                 textInputAction: TextInputAction.search,
//                 onChanged: (q) {
//                   _currentSearch = q.trim().isEmpty ? null : q.trim();
//                   _load();
//                 },
//                 onSubmitted: (q) {
//                   _currentSearch = q.trim().isEmpty ? null : q.trim();
//                   _load();
//                 },
//               ),
//             ]),
//           ),
//         ]),
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Added widget here as requested
//             // Container(
//             //   padding: const EdgeInsets.all(16),
//             //   color: Colors.grey[200],
//             //   child: const Text(
//             //     'Document Browser',
//             //     style: TextStyle(
//             //       fontSize: 18,
//             //       fontWeight: FontWeight.bold,
//             //     ),
//             //   ),
//             // ),
//             Expanded(
//               child: _isLoadingData
//                   ? const Center(child: CircularProgressIndicator())
//                   : Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildBreadcrumbs(),
//                   const SizedBox(height: 12),
//                   Expanded(
//                     child: ListView.builder(
//                       controller: _scrollController,
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       itemCount: _allItems.length > _currentMax
//                           ? _currentMax + 1
//                           : _allItems.length,
//                       itemBuilder: (ctx, i) {
//                         if (i == _currentMax && _isLoadingMore) {
//                           return const Padding(
//                             padding: EdgeInsets.all(8),
//                             child: Center(
//                               child: CircularProgressIndicator(),
//                             ),
//                           );
//                         }
//                         final item = _allItems[i];
//                         return item.isFolder
//                             ? _buildFolderItem(item.folder!)
//                             : _buildFileItem(item.file!);
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:my_app/pages/documents/document_model.dart';
import 'package:my_app/pages/documents/preview_page.dart';
import '../../config/theme.dart';

/// Wraps a folder or file for unified display
class _Item {
  final FolderItem? folder;
  final FileItem? file;
  bool get isFolder => folder != null;

  _Item.folder(this.folder) : file = null;
  _Item.file(this.file) : folder = null;
}

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<FilesScreen> createState() => _FilesScreenState();
}

class _FilesScreenState extends State<FilesScreen> {
  int? _currentClientId;
  int? _currentFolderId;
  String? _currentSearch;

  bool _isLoadingData = true;
  bool _isLoadingMore = false;
  int _currentMax = 7;
  List<_Item> _allItems = [];
  FilesFoldersResponse? _lastResponse;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _fetchData() {
    setState(() {
      _isLoadingData = true;
      _isLoadingMore = false;
      _currentMax = 7;
    });

    DocumentRepository()
        .fetch(
      clientId: _currentClientId,
      folderId: _currentFolderId,
      search: _currentSearch,
    )
        .then((resp) {
      final items = <_Item>[
        ...resp.folders.map((f) => _Item.folder(f)),
        ...resp.files.map((f) => _Item.file(f))
      ];
      setState(() {
        _lastResponse = resp;
        _allItems = items;
        _isLoadingData = false;
        _currentMax = min(_currentMax, _allItems.length);
      });
    }).catchError((e) {
      setState(() => _isLoadingData = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error loading data: $e')));
    });
  }

  void _loadMore() {
    if (_isLoadingMore || _currentMax >= _allItems.length) return;
    setState(() => _isLoadingMore = true);
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _currentMax = min(_currentMax + 7, _allItems.length);
        _isLoadingMore = false;
      });
    });
  }

  void _goHome() {
    _currentClientId = null;
    _currentFolderId = null;
    _currentSearch = null;
    _searchController.clear();
    _fetchData();
  }

  void _enterClient(int clientId) {
    _currentClientId = clientId;
    _currentFolderId = null;
    _currentSearch = null;
    _searchController.clear();
    _fetchData();
  }

  void _enterFolder(int folderId) {
    _currentFolderId = folderId;
    _currentSearch = null;
    _searchController.clear();
    _fetchData();
  }

  Widget _crumb(String text, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Text(text,
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: "inter",
            )),
      );

  Widget _sep() => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text('/', style: TextStyle(fontWeight: FontWeight.w600)),
      );

  Widget _buildBreadcrumbs() {
    if (_lastResponse == null) return const SizedBox.shrink();
    final crumbs = <Widget>[];
    crumbs.add(_crumb('Home', _goHome));
    if (_lastResponse!.breadcrumbs.isNotEmpty) {
      final root = _lastResponse!.breadcrumbs.first;
      final client = _lastResponse!.clientDetails.firstWhere(
        (c) => c.id == root.clientId,
        orElse: () => ClientDetail(id: root.clientId, name: ''),
      );
      crumbs.add(_sep());
      crumbs.add(_crumb(client.name, () => _enterClient(client.id)));
      for (final bc in _lastResponse!.breadcrumbs) {
        crumbs.add(_sep());
        crumbs.add(_crumb(bc.name, () => _enterFolder(bc.id)));
      }
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: crumbs),
    );
  }

  Widget _buildRow(
      Widget icon, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFDDDDDD)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: Colors.grey)),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildFolderItem(FolderItem f) => _buildRow(
      const Icon(Icons.folder, size: 24, color: Colors.orange),
      f.name,
      f.createdAt,
      () => _enterFolder(f.id));

  Widget _buildFileItem(FileItem f) {
    final icon = f.fileName.toLowerCase().endsWith('.pdf')
        ? Image.asset('images/pdf.png', width: 18, height: 24)
        : Image.asset('images/jpg.png', width: 18, height: 24);
    return _buildRow(icon, f.fileName, f.createdAt, () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => FilePreviewPage(fileId: f.id, fileName: f.fileName),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _allItems.length;
    final showLoader = _isLoadingMore && _currentMax < total;
    final itemCount = showLoader ? _currentMax + 1 : _currentMax;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 130,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Stack(children: [
            Container(color: Theme.of(context).colorScheme.primary),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              child: Column(children: [
                Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text('Files',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(color: Colors.white)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: const [
                      Icon(Icons.add_circle_outline,
                          size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      Text('New File',
                          style: TextStyle(color: Colors.white, fontSize: 11)),
                    ]),
                  ),
                ]),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    hintText: 'Search files or folders...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.search, size: 18),
                    isDense: true,
                  ),
                  textInputAction: TextInputAction.search,
                  onChanged: (q) {
                    _currentSearch = q.trim().isEmpty ? null : q.trim();
                    _fetchData();
                  },
                  onSubmitted: (_) => _fetchData(),
                ),
              ]),
            ),
          ]),
        ),
        body: SafeArea(
          child: _isLoadingData
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBreadcrumbs(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notif) {
                          if (notif.metrics.pixels >=
                                  notif.metrics.maxScrollExtent - 50 &&
                              !_isLoadingMore &&
                              _currentMax < total) {
                            _loadMore();
                          }
                          return false;
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: itemCount,
                          itemBuilder: (ctx, i) {
                            if (showLoader && i == _currentMax) {
                              return const Padding(
                                padding: EdgeInsets.all(8),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                            final item = _allItems[i];
                            return item.isFolder
                                ? _buildFolderItem(item.folder!)
                                : _buildFileItem(item.file!);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
