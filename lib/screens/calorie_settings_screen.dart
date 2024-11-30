import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'ingredients_screen.dart';

class CalorieSettingsScreen extends StatefulWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;
  final String servingSize;
  final int initialCalories;
  final Function(int) onCaloriesSelected;

  const CalorieSettingsScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
    required this.servingSize,
    required this.initialCalories,
    required this.onCaloriesSelected,
  });

  @override
  State<CalorieSettingsScreen> createState() => _CalorieSettingsScreenState();
}

class _CalorieSettingsScreenState extends State<CalorieSettingsScreen> {
  late TextEditingController _caloriesController;
  final List<int> _presetCalories = const [1200, 1500, 1800, 2000, 2200, 2500];

  @override
  void initState() {
    super.initState();
    _caloriesController = TextEditingController(
      text: widget.initialCalories > 0 ? widget.initialCalories.toString() : '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Set Target Calories',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter Target Calories',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Enter calories',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Preset Options',
              style: AppTextStyles.heading,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presetCalories.map((calories) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _caloriesController.text = calories.toString();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: Text('$calories cal'),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAndNavigateToNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndNavigateToNext() {
    final calories = int.tryParse(_caloriesController.text) ?? 0;
    if (calories > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IngredientsScreen(
            mealType: widget.mealType,
            dietaryPreferences: widget.dietaryPreferences,
            allergies: widget.allergies,
            cuisineType: widget.cuisineType,
            servingSize: widget.servingSize,
            targetCalories: calories,
          ),
        ),
      );
    } else {
      // Show error if calories not set
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid calorie target'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    super.dispose();
  }
}
