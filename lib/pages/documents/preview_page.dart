import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:my_app/backend/api_requests/file_api.dart';

class FilePreviewPage extends StatefulWidget {
  final int fileId;
  final String fileName;
  const FilePreviewPage(
      {Key? key, required this.fileId, required this.fileName})
      : super(key: key);

  @override
  _FilePreviewPageState createState() => _FilePreviewPageState();
}

class _FilePreviewPageState extends State<FilePreviewPage> {
  late Future<String> _filePathFuture;

  @override
  void initState() {
    super.initState();
    _filePathFuture = _prepareFile();
  }

  Future<String> _prepareFile() async {
    final bytes = await FileApi.previewFile(widget.fileId);
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${widget.fileId}_${widget.fileName}');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName, overflow: TextOverflow.ellipsis),
      ),
      body: FutureBuilder<String>(
        future: _filePathFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('File not available'));
          }
          return PDFView(
            filePath: snapshot.data!,
          );
        },
      ),
    );
  }
}
