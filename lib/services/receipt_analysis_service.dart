import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ReceiptAnalysisService {
  final String apiUrl = 'http://54.173.54.132:8010/api/receipt/analyze';
  final String bearerToken = '9357';

  Future<List<String>> analyzeReceipt(File receiptImage) async {
    final request = http.MultipartRequest('POST', Uri.parse(apiUrl))
      ..headers['Authorization'] = 'Bearer $bearerToken'
      ..headers['accept'] = 'application/json'
      ..files.add(await http.MultipartFile.fromPath(
        'receipt',
        receiptImage.path,
        contentType: MediaType('image', 'jpeg'),
      ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    print('Response body: $responseBody');
    final data = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      final ingredients = data['data']?['ingredients'];
      return ingredients != null 
          ? List<String>.from(ingredients)
          : <String>[];
    } else {
      print('Error response: $responseBody');
      throw Exception('Failed to analyze receipt: ${response.statusCode}');
    }
  }
} 