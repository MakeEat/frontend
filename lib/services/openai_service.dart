import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey;

  OpenAIService(this.apiKey);

  Future<String> generateRecipe({
    required String mealType,
    required String cuisine,
    required String servingSize,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> ingredients,
  }) async {
    final url = Uri.parse("https://api.openai.com/v1/completions");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: jsonEncode({
        "model": "text-davinci-003",
        "prompt": _buildPrompt(
          mealType: mealType,
          cuisine: cuisine,
          servingSize: servingSize,
          dietaryPreferences: dietaryPreferences,
          allergies: allergies,
          ingredients: ingredients,
        ),
        "max_tokens": 300,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['choices'][0]['text'].trim();
    } else {
      throw Exception('Failed to generate recipe: ${response.statusCode}');
    }
  }

  String _buildPrompt({
    required String mealType,
    required String cuisine,
    required String servingSize,
    required List<String> dietaryPreferences,
    required List<String> allergies,
    required List<String> ingredients,
  }) {
    final dietaryText = dietaryPreferences.isNotEmpty
        ? "Dietary preferences: ${dietaryPreferences.join(', ')}."
        : "No specific dietary preferences.";
    final allergiesText = allergies.isNotEmpty
        ? "Avoid these allergens: ${allergies.join(', ')}."
        : "No allergies.";
    final ingredientsText = ingredients.isNotEmpty
        ? "Include these ingredients: ${ingredients.join(', ')}."
        : "No specific ingredients.";

    return """
Generate a $mealType recipe for $servingSize people. The cuisine type is $cuisine. 
$allergiesText $dietaryText $ingredientsText
Provide step-by-step instructions and a list of ingredients.
    """;
  }
}
