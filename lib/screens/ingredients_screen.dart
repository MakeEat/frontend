import 'package:flutter/material.dart';
import 'confirmation_screen.dart';
import 'camera_capture_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;
  final String servingSize;
  final int targetCalories;
  final List<String>? existingIngredients;

  const IngredientsScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
    required this.servingSize,
    required this.targetCalories,
    this.existingIngredients,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  static const int maxIngredients = 3;
  late List<String> ingredients;
  final TextEditingController ingredientController = TextEditingController();
  final FocusNode ingredientFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ingredients = widget.existingIngredients?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAF5), Color(0xFFFFE3C1)],
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
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              top: 130,
              right: 16,
              bottom: 100,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Final touch:\nWhat ingredients do you have?',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 32,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.60,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Add ingredients you\'d like to include in your recipe',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ingredient Input
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(color: Color(0xFFCCCCCC)),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ingredientController,
                              focusNode: ingredientFocusNode,
                              style: const TextStyle(
                                fontSize: 18,
                                fontFamily: 'DM Sans',
                                color: Color(0xFF191919),
                              ),
                              decoration: const InputDecoration(
                                hintText: "Enter an ingredient",
                                hintStyle: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 18,
                                  fontFamily: 'DM Sans',
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onSubmitted: (value) => _addIngredient(value),
                            ),
                          ),
                          IconButton(
                            onPressed: () => _addIngredient(ingredientController.text),
                            icon: const Icon(Icons.add_circle),
                            color: const Color(0xFFF48600),
                            iconSize: 32,
                            padding: const EdgeInsets.all(12),
                          ),
                          IconButton(
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CameraCaptureScreen(),
                                ),
                              );
                              _handleCameraResult(result as List<String>?);
                            },
                            icon: const Icon(Icons.camera_alt),
                            color: const Color(0xFFF48600),
                            iconSize: 32,
                            padding: const EdgeInsets.all(12),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ingredients List
                    ingredients.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Add ingredients to create\nyour perfect recipe!",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: ingredients.asMap().entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFFE3C1),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xFFF48600),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        color: Color(0xFF191919),
                                        fontSize: 18,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _removeIngredient(entry.key),
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Color(0xFFF48600),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),

            // Generate Recipe Button
            Positioned(
              left: 17,
              bottom: 40,
              right: 17,
              child: ElevatedButton(
                onPressed: ingredients.isNotEmpty ? _navigateToConfirmation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '✨ Generate Recipe',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addIngredient(String ingredient) {
    final trimmed = ingredient.trim();
    if (trimmed.isNotEmpty && !ingredients.contains(trimmed)) {
      setState(() {
        ingredients.add(trimmed);
        ingredientController.clear();
      });
      ingredientFocusNode.requestFocus();
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          mealType: widget.mealType,
          dietaryPreferences: widget.dietaryPreferences,
          allergies: widget.allergies,
          cuisineType: widget.cuisineType,
          servingSize: widget.servingSize,
          ingredients: ingredients,
          targetCalories: widget.targetCalories,
        ),
      ),
    );
  }

  void _handleCameraResult(List<String>? selectedIngredients) {
    if (selectedIngredients != null) {
      setState(() {
        for (final ingredient in selectedIngredients) {
          if (!ingredients.contains(ingredient)) {
            ingredients.add(ingredient);
          }
        }
      });
    }
  }
}
