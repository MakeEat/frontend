import 'dart:typed_data';

abstract class SaveUtils {
  Future<void> saveFile(Uint8List bytes, String fileName);
} 