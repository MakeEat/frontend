import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'confirmation_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;
  final String servingSize;
  final int targetCalories;

  const IngredientsScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
    required this.servingSize,
    required this.targetCalories,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  String mealType = '';
  List<String> dietaryPreferences = [];
  List<String> allergies = [];
  String cuisineType = '';
  String servingSize = '';
  List<String> ingredients = [];
  int targetCalories = 0;
  final TextEditingController ingredientController = TextEditingController();
  final FocusNode ingredientFocusNode = FocusNode();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    mealType = widget.mealType;
    dietaryPreferences = widget.dietaryPreferences;
    allergies = widget.allergies;
    cuisineType = widget.cuisineType;
    servingSize = widget.servingSize;
    targetCalories = widget.targetCalories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ingredients",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAFAFA), Color(0xFFFFF4ED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "What ingredients do you have?",
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Add ingredients you'd like to use",
                style: AppTextStyles.body.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: ingredientController,
                      focusNode: ingredientFocusNode,
                      decoration: const InputDecoration(
                        hintText: "Enter an ingredient",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                      ),
                      onSubmitted: (value) => _addIngredient(value),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => _addIngredient(ingredientController.text),
                    icon: const Icon(Icons.add_circle),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ingredients.isEmpty
                    ? Center(
                        child: Text(
                          "Add some ingredients to get started!",
                          style: AppTextStyles.body.copyWith(
                            color: Colors.grey[600],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: ingredients.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: ListTile(
                              title: Text(
                                ingredients[index],
                                style: AppTextStyles.body,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: Colors.red,
                                onPressed: () => _removeIngredient(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text("Back"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: ingredients.isNotEmpty
                          ? () => _navigateToConfirmation()
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text("Generate Recipe"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          mealType: mealType,
          dietaryPreferences: dietaryPreferences,
          allergies: allergies,
          cuisineType: cuisineType,
          servingSize: servingSize,
          ingredients: ingredients,
          targetCalories: targetCalories,
        ),
      ),
    );
  }
}
