import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'calorie_settings_screen.dart';
import 'ingredients_screen.dart';

class ServingSizeScreen extends StatefulWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;

  const ServingSizeScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
  });

  @override
  State<ServingSizeScreen> createState() => _ServingSizeScreenState();
}

class _ServingSizeScreenState extends State<ServingSizeScreen> {
  int servingSize = 2;
  
  final List<int> quickSelections = [1, 2, 4, 6];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Serving Size"),
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
                "How many servings?",
                style: AppTextStyles.heading,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Select or adjust the number of servings",
                style: AppTextStyles.body.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Quick selection buttons
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: quickSelections.map((size) => 
                  _buildQuickSelectButton(size)
                ).toList(),
              ),
              const SizedBox(height: 40),
              // Custom serving size selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      if (servingSize > 1) {
                        setState(() => servingSize--);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                  Container(
                    width: 100,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Text(
                      servingSize.toString(),
                      style: AppTextStyles.body.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (servingSize < 20) {
                        setState(() => servingSize++);
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                    color: AppColors.primary,
                    iconSize: 32,
                  ),
                ],
              ),
              const Spacer(),
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
                      onPressed: _navigateToCalorieSettings,
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text("Next"),
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

  Widget _buildQuickSelectButton(int size) {
    final isSelected = servingSize == size;
    return ElevatedButton(
      onPressed: () => setState(() => servingSize = size),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.primary : Colors.white,
        foregroundColor: isSelected ? Colors.white : AppColors.primary,
        elevation: isSelected ? 8 : 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.primary,
            width: isSelected ? 2 : 1,
          ),
        ),
      ),
      child: Text(
        "$size ${size == 1 ? 'serving' : 'servings'}",
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.primary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  void _navigateToCalorieSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalorieSettingsScreen(
          mealType: widget.mealType,
          dietaryPreferences: widget.dietaryPreferences,
          allergies: widget.allergies,
          cuisineType: widget.cuisineType,
          servingSize: servingSize.toString(),
          initialCalories: 2000,
          onCaloriesSelected: (calories) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => IngredientsScreen(
                  mealType: widget.mealType,
                  dietaryPreferences: widget.dietaryPreferences,
                  allergies: widget.allergies,
                  cuisineType: widget.cuisineType,
                  servingSize: servingSize.toString(),
                  targetCalories: calories,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
