import 'dart:convert';
import 'package:http/http.dart' as http;
import 'fatsecret_service.dart';

class OpenAIService {
  final String apiKey;
  final FatSecretService fatSecretService;

  OpenAIService(this.apiKey)
      : fatSecretService = FatSecretService(
          'dfd573663388464eb77f353fbef3a292',
          'ddc36747bd0d4a9b835bc00a8db27d85',
        );

  Future<String> generateRecipe({
    required String mealType,
    required String cuisineType,
    required List<String> dietaryRestrictions,
    required List<String> allergies,
    required int servings,
    required int calorieLimit,
    required List<String> ingredients,
    required Map<String, String> additionalPreferences,
  }) async {
    final url = Uri.parse('http://54.173.54.132:8010/api/recipe/generate');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'meal_type': mealType,
        'cuisine_type': cuisineType,
        'dietary_restrictions': dietaryRestrictions,
        'allergies': allergies,
        'servings': servings,
        'calorie_limit': calorieLimit,
        'ingredients': ingredients,
        'additional_preferences': additionalPreferences,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['recipe'];
    } else {
      throw Exception('Failed to generate recipe: ${response.statusCode}');
    }
  }
}
