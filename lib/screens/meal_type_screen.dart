import 'package:flutter/material.dart';
import 'cuisine_type_screen.dart';
import '../utils/theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose Meal Type"),
        backgroundColor: AppColors.primary,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAF9F6), Color(0xFFFFF4ED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                const Text(
                  "What type of meal are you planning?",
                  style: TextStyle(
                    fontSize: 28,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  children: [
                    _buildMealTypeCard(
                      context,
                      "Breakfast",
                      Icons.breakfast_dining,
                      "Start your day right",
                    ),
                    _buildMealTypeCard(
                      context,
                      "Lunch",
                      Icons.lunch_dining,
                      "Midday fuel",
                    ),
                    _buildMealTypeCard(
                      context,
                      "Dinner",
                      Icons.dinner_dining,
                      "Evening delight",
                    ),
                    _buildMealTypeCard(
                      context,
                      "Snack",
                      Icons.cookie,
                      "Quick bites",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeCard(
    BuildContext context,
    String title,
    IconData icon,
    String subtitle,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedMealType = title;
        });
        _navigateToCuisineType();
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFFFF4ED)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: const Color(0xFFFF7F50),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF777777),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
