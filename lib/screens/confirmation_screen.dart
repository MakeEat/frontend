import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'recipe_display_screen.dart';
import '../models/recipe.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';

class ConfirmationScreen extends StatefulWidget {
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

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> with SingleTickerProviderStateMixin {
  late List<String> combinedAllergies;
  late List<String> combinedPreferences;
  late List<String> excludedIngredients;
  bool isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  
  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserPreferences() async {
    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    
    // Get saved preferences
    final savedDiet = prefsService.getDiet();
    final savedAllergies = prefsService.getAllergies();
    final savedDislikes = prefsService.getDislikes();
    
    setState(() {
      // Remove duplicates from allergies
      combinedAllergies = {...widget.allergies, ...savedAllergies}.toList();
      
      // Remove duplicates from dietary preferences
      Set<String> prefsSet = {...widget.dietaryPreferences};
      if (savedDiet != null && savedDiet != 'Classic') {
        prefsSet.add(savedDiet);
      }
      combinedPreferences = prefsSet.toList();
      
      // Add disliked ingredients to excluded ingredients
      excludedIngredients = savedDislikes;
    });
  }

  Future<void> _generateRecipe(BuildContext context) async {
    try {
      setState(() => isLoading = true);
      
      // Take only first 2 items from each list to reduce token count
      final limitedPreferences = combinedPreferences.take(2).toList();
      final limitedAllergies = combinedAllergies.take(2).toList();

      final response = await http.post(
        Uri.parse('http://54.173.54.132:8010/api/recipe/generate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer 9357',
        },
        body: jsonEncode({
          'meal_type': widget.mealType,
          'cuisine_type': widget.cuisineType,
          'dietary_restrictions': limitedPreferences, // Use combined preferences
          'allergies': limitedAllergies, // Use combined allergies
          'servings': int.parse(widget.servingSize),
          'calorie_limit': widget.targetCalories,
          'ingredients': widget.ingredients,
          'additional_preferences': {
            'dislikes': excludedIngredients, // Use excluded ingredients
          },
        }),
      );

      if (!mounted) return;
      
      if (response.statusCode == 200 || response.statusCode == 201) {  // Accept both 200 and 201
        final data = jsonDecode(response.body);
        
        // The recipe data is directly in the response, no need to parse message content
        final recipeData = data['data'];
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDisplayScreen(
                recipe: Recipe.fromJson(recipeData),
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${response.statusCode} - ${response.body}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to generate recipe. Please try again.')),
      );
    }
  }

  String _buildPrompt() {
    return '''
    Generate a recipe with the following requirements:
    - Meal Type: ${widget.mealType}
    - Dietary Preferences: ${combinedPreferences.join(', ')}
    - Allergies to avoid: ${combinedAllergies.join(', ')}
    - Ingredients to exclude: ${excludedIngredients.join(', ')}
    - Cuisine Type: ${widget.cuisineType}
    - Serving Size: ${widget.servingSize} people
    - Target Calories: ${widget.targetCalories}
    - Required Ingredients: ${widget.ingredients.join(', ')}
    
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: const Color(0xFFFFFAF5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Stack(
          children: [
            // Back Button
            Positioned(
              left: 16,
              top: 54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),

            // Main Content
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 120,
                left: 16,
                right: 16,
                bottom: 120,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Confirm Recipe Details',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSection('Meal Type', widget.mealType),
                  _buildSection(
                    'Dietary Preferences',
                    combinedPreferences.isEmpty ? 'None' : combinedPreferences.join(', '),
                  ),
                  _buildSection(
                    'Allergies',
                    combinedAllergies.isEmpty ? 'None' : combinedAllergies.join(', '),
                  ),
                  _buildSection('Cuisine Type', widget.cuisineType),
                  _buildSection('Serving Size', widget.servingSize),
                  _buildIngredientsList(),
                  _buildSection('Target Calories', widget.targetCalories.toString()),
                ],
              ),
            ),

            // Generate Recipe Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: SizedBox(
                height: 57,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _generateRecipe(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Generate Recipe',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            if (isLoading) _buildLoadingOverlay(),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF191919),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              color: Color(0xFF191919),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ...widget.ingredients.map((ingredient) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF666666),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  ingredient,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return AnimatedOpacity(
      opacity: isLoading ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Transform.rotate(
                      angle: _rotationAnimation.value,
                      child: Image.asset(
                        'assets/images/makeeat_logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Cooking up your recipe...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}