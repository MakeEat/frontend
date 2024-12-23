import 'package:flutter/material.dart';
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
      body: Container(
        width: 430,
        height: 932,
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
                onPressed: () => Navigator.pop(context),
              ),
            ),
            
            // Progress Indicator
            Positioned(
              left: 16,
              top: 94,
              child: SizedBox(
                width: 398,
                child: Row(
                  children: List.generate(5, (index) {
                    return Expanded(
                      child: Container(
                        height: 12,
                        margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                        decoration: ShapeDecoration(
                          color: index < 5
                              ? const Color(0xFF33985B)
                              : const Color(0xFFE6E6E6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              top: 130,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set target calories',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Custom Calorie Input
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: TextField(
                      controller: _caloriesController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        color: Color(0xFF191919),
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Enter calories',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Preset Options
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _presetCalories.map((calories) {
                      final isSelected = _caloriesController.text == calories.toString();
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _caloriesController.text = calories.toString();
                          });
                        },
                        child: Container(
                          width: 107,
                          height: 57,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: ShapeDecoration(
                            color: isSelected ? const Color(0xFFFFE3C1) : Colors.white,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: isSelected ? const Color(0xFFF48600) : const Color(0xFFCCCCCC),
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '$calories cal',
                                style: TextStyle(
                                  color: const Color(0xFF191919),
                                  fontSize: 18,
                                  fontFamily: 'DM Sans',
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Continue Button
            Positioned(
              left: 17,
              bottom: 40,
              child: SizedBox(
                width: 397,
                height: 57,
                child: ElevatedButton(
                  onPressed: _saveAndNavigateToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
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
          ],
        ),
      ),
    );
  }

  void _saveAndNavigateToNext() {
    final totalCalories = int.tryParse(_caloriesController.text) ?? 0;
    final servingSize = int.tryParse(widget.servingSize) ?? 1;
    final caloriesPerServing = totalCalories ~/ servingSize; // Integer division

    if (caloriesPerServing > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IngredientsScreen(
            mealType: widget.mealType,
            dietaryPreferences: widget.dietaryPreferences,
            allergies: widget.allergies,
            cuisineType: widget.cuisineType,
            servingSize: widget.servingSize,
            targetCalories: caloriesPerServing,
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
