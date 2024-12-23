import 'package:flutter/material.dart';
import 'meal_type_screen.dart';
import '../models/recipe.dart';

class RecipeAIScreen extends StatefulWidget {
  const RecipeAIScreen({super.key});

  @override
  State<RecipeAIScreen> createState() => _RecipeAIScreenState();
}

class _RecipeAIScreenState extends State<RecipeAIScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFFFF4ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Create your perfect meal',
                  textAlign: TextAlign.center,
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
                  'Let our AI help you discover new recipes tailored to your preferences and dietary needs.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    final recipe = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MealTypeScreen(),
                      ),
                    );
                    
                    if (!mounted) return;
                    
                    if (recipe != null && recipe is Recipe) {
                      Navigator.pop(context, recipe);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 57,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFF48600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Start Cooking',
                      textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
} 