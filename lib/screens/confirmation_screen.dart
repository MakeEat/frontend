import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'recipe_display_screen.dart';
import '../models/recipe.dart';

class ConfirmationScreen extends StatelessWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;
  final String servingSize;
  final List<String> ingredients;
  final int targetCalories;

  const ConfirmationScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
    required this.servingSize,
    required this.ingredients,
    required this.targetCalories,
  });

  Future<void> _generateRecipe(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7F6F)),
            ),
          );
        },
      );

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${dotenv.env['OPENAI_API_KEY']}',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': _buildPrompt(),
            }
          ],
          'temperature': 0.7,
        }),
      );

      if (!context.mounted) return;
      Navigator.pop(context); // Remove loading dialog

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final recipeContent = data['choices'][0]['message']['content'];
        
        // Parse the string content into a Map
        final recipeJson = jsonDecode(recipeContent);
        
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDisplayScreen(
                recipe: Recipe.fromJson(recipeJson),
              ),
            ),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode} - ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      print('Error in _generateRecipe: $e');
    }
  }

  String _buildPrompt() {
    return '''
    Generate a recipe with the following requirements:
    - Meal Type: $mealType
    - Dietary Preferences: ${dietaryPreferences.join(', ')}
    - Allergies to avoid: ${allergies.join(', ')}
    - Cuisine Type: $cuisineType
    - Serving Size: $servingSize people
    - Target Calories: $targetCalories
    - Required Ingredients: ${ingredients.join(', ')}
    
    Please provide the recipe in JSON format with the following structure:
    {
      "title": "Recipe Name",
      "description": "Brief description",
      "ingredients": ["ingredient 1", "ingredient 2"],
      "instructions": ["step 1", "step 2"],
      "cookTime": "30 minutes",
      "servings": "4",
      "nutritionalInfo": {
        "calories": 500,
        "protein": 20,
        "carbohydrates": 60,
        "fat": 25,
        "fiber": 5,
        "sugar": 10,
        "sodium": 500
      }
    }
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Confirm Recipe Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        backgroundColor: const Color(0xFFFF7F6F),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection('Meal Type', mealType),
              _buildSection(
                'Dietary Preferences',
                dietaryPreferences.isEmpty ? 'None' : dietaryPreferences.join(', '),
              ),
              _buildSection(
                'Allergies',
                allergies.isEmpty ? 'None' : allergies.join(', '),
              ),
              _buildSection('Cuisine Type', cuisineType),
              _buildSection('Serving Size', servingSize),
              _buildIngredientsList(),
              _buildSection('Target Calories', targetCalories.toString()),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _generateRecipe(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7F6F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Generate Recipe',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
        const Divider(
          height: 32,
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        ...ingredients.map((ingredient) => Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                ingredient,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        )),
        const Divider(
          height: 32,
          thickness: 1,
        ),
      ],
    );
  }
}