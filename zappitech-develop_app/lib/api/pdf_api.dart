import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file_safe/open_file_safe.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
//import 'dart:html' as html;

class PdfApi {
  static Future<File> saveDocument({
    String? name,
    Document? pdf,
  }) async {
    final bytes = await pdf?.save();
    // if (kIsWeb) {
    //   final bytes = await pdf.save();
    //   final blob = html.Blob([bytes], 'application/pdf');
    //   final url = html.Url.createObjectUrlFromBlob(blob);
    //   html.window.open(url, '_blank');
    //   html.Url.revokeObjectUrl(url);
    // } else {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');

      await file.writeAsBytes(bytes!);

      return file;
    // }
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
