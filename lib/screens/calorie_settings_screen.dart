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
  late double _currentCalories;
  final double _minCalories = 500;
  final double _maxCalories = 3000;
  final double _step = 100;

  @override
  void initState() {
    super.initState();
    _currentCalories = widget.initialCalories > 0 
        ? widget.initialCalories.toDouble() 
        : 2000;
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
                    'Set total calories',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Target calories for each serving',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  
                  // Calories Display
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${_currentCalories.toInt()}',
                          style: const TextStyle(
                            color: Color(0xFFF48600),
                            fontSize: 48,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'calories',
                          style: TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 18,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Slider
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFFF48600),
                      inactiveTrackColor: const Color(0xFFFFE3C1),
                      thumbColor: const Color(0xFFF48600),
                      overlayColor: const Color(0xFFF48600).withOpacity(0.2),
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 12,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 24,
                      ),
                    ),
                    child: Slider(
                      value: _currentCalories,
                      min: _minCalories,
                      max: _maxCalories,
                      divisions: ((_maxCalories - _minCalories) ~/ _step),
                      onChanged: (value) {
                        setState(() {
                          _currentCalories = value - (value % _step);
                        });
                      },
                    ),
                  ),
                  
                  // Min/Max Labels
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_minCalories.toInt()} cal',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                        Text(
                          '${_maxCalories.toInt()} cal',
                          style: const TextStyle(
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontFamily: 'DM Sans',
                          ),
                        ),
                      ],
                    ),
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
    final caloriesPerServing = _currentCalories.toInt();

    if (caloriesPerServing > 0) {
      widget.onCaloriesSelected(caloriesPerServing);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid calorie target'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
