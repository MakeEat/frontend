import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

Future<String> saveFileMobile(Uint8List bytes, String fileName) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = '${directory.path}/$fileName';
  final file = File(path);
  await file.writeAsBytes(bytes);
  return path;
} 