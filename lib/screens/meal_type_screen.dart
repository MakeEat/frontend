import 'package:flutter/material.dart';
import 'cuisine_type_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MealTypeScreen extends StatefulWidget {
  const MealTypeScreen({super.key});

  @override
  State<MealTypeScreen> createState() => _MealTypeScreenState();
}

class _MealTypeScreenState extends State<MealTypeScreen> {
  String _selectedMealType = '';
  List<String> _selectedCuisines = [];

  void _navigateToCuisineType() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CuisineTypeScreen(
          selectedCuisines: _selectedCuisines,
          onCuisinesSelected: (cuisines) {
            setState(() {
              _selectedCuisines = cuisines;
            });
          },
          mealType: _selectedMealType,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get current time
    final now = TimeOfDay.now();
    String recommendedMeal = '';
    
    // Determine recommended meal based on time
    if (now.hour >= 5 && now.hour < 11) {
      recommendedMeal = 'Breakfast';
    } else if (now.hour >= 11 && now.hour < 15) {
      recommendedMeal = 'Lunch';
    } else if (now.hour >= 15 && now.hour < 18) {
      recommendedMeal = 'Snack';
    } else {
      recommendedMeal = 'Dinner';
    }

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
                          color: index < 1 
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

            // Updated Main Content
            Positioned(
              left: 16,
              right: 16,
              top: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What type of meal\nare you planning?',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'It\'s ${now.format(context)} - Perfect time for $recommendedMeal!',
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 24),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 12) / 2;
                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildMealTypeCard("Breakfast", "assets/icons/breakfast.svg", "Start your day right", cardWidth),
                          _buildMealTypeCard("Lunch", "assets/icons/lunch.svg", "Midday fuel", cardWidth),
                          _buildMealTypeCard("Dinner", "assets/icons/dinner.svg", "Evening delight", cardWidth),
                          _buildMealTypeCard("Snack", "assets/icons/snack.svg", "Quick bites", cardWidth),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTypeCard(String title, String iconPath, String subtitle, double width) {
    final isSelected = _selectedMealType == title;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMealType = title;
        });
        _navigateToCuisineType();
      },
      child: Container(
        width: width,
        height: width,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 48,
              height: 48,
              color: const Color(0xFFF48600),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF191919),
                fontSize: 18,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF777777),
                fontFamily: 'DM Sans',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
