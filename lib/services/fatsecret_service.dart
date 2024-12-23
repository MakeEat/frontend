import 'dart:convert';
import 'package:http/http.dart' as http;

class FatSecretService {
  final String clientId;
  final String clientSecret;

  FatSecretService(this.clientId, this.clientSecret);

  Future<Map<String, dynamic>> fetchNutritionalInfo(String ingredient) async {
    final url = Uri.parse('https://platform.fatsecret.com/rest/server.api');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization": "Bearer $clientId:$clientSecret"
      },
      body: {
        "method": "foods.search",
        "search_expression": ingredient,
        "format": "json"
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['foods']['food'][0]['nutrients'];
    } else {
      throw Exception('Failed to fetch nutritional info: ${response.statusCode}');
    }
  }
} 