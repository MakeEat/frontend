import 'package:flutter/material.dart';
import '../widgets/result_card.dart';

class ResultScreen extends StatelessWidget {
  final String mealType;
  final String dietaryRestrictions;
  final String allergies;
  final String peopleCount;
  final String ingredients;

  const ResultScreen({
    super.key,
    required this.mealType,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.peopleCount,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    final recipe = _generateRecipe();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Recipe'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ResultCard(recipe: recipe),
      ),
    );
  }

  String _generateRecipe() {
    return '''
Meal Type: $mealType
Dietary Restrictions: $dietaryRestrictions
Allergies: $allergies
Serves: $peopleCount
Ingredients: $ingredients

Instructions:
1. Use your listed ingredients and cook a meal based on the above details.
2. Experiment and enjoy!
    ''';
  }
}
