import 'package:flutter/material.dart';
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
                          color: index < 4 
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
                    'How many servings?',
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
                    'Select or adjust the number of servings',
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Quick Selection Buttons
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: quickSelections.map((size) {
                      final isSelected = servingSize == size;
                      return GestureDetector(
                        onTap: () => setState(() => servingSize = size),
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
                            child: Text(
                              "$size ${size == 1 ? 'serving' : 'servings'}",
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
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  // Custom Serving Size Selector
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xFFCCCCCC)),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            if (servingSize > 1) {
                              setState(() => servingSize--);
                            }
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                          color: const Color(0xFFF48600),
                          iconSize: 32,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          servingSize.toString(),
                          style: const TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 24,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          onPressed: () {
                            if (servingSize < 20) {
                              setState(() => servingSize++);
                            }
                          },
                          icon: const Icon(Icons.add_circle_outline),
                          color: const Color(0xFFF48600),
                          iconSize: 32,
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
                  onPressed: _navigateToCalorieSettings,
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
