import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'allergies_screen.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  final List<String> selectedPreferences;
  final String mealType;
  final String cuisineType;
  final Function(List<String>) onPreferencesSelected;

  const DietaryPreferencesScreen({
    super.key,
    required this.selectedPreferences,
    required this.mealType,
    required this.cuisineType,
    required this.onPreferencesSelected,
  });

  @override
  State<DietaryPreferencesScreen> createState() => _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  late List<String> _selectedPreferences;

  final List<String> _dietaryOptions = [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Gluten-Free',
    'Dairy-Free',
    'Keto',
    'Paleo',
    'Low-Carb',
    'Low-Fat',
    'Mediterranean',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _selectedPreferences = List.from(widget.selectedPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dietary Preferences',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Select Your Dietary Preferences',
                style: AppTextStyles.heading,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _dietaryOptions.length,
              itemBuilder: (context, index) {
                final option = _dietaryOptions[index];
                return CheckboxListTile(
                  title: Text(option),
                  value: _selectedPreferences.contains(option),
                  activeColor: AppColors.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (option == 'None') {
                          _selectedPreferences.clear();
                        } else {
                          _selectedPreferences.remove('None');
                        }
                        _selectedPreferences.add(option);
                      } else {
                        _selectedPreferences.remove(option);
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _navigateToAllergies,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Next'),
          ),
        ),
      ),
    );
  }

  void _navigateToAllergies() {
    widget.onPreferencesSelected(_selectedPreferences);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllergiesScreen(
          allergies: const [],
          mealType: widget.mealType,
          dietaryPreferences: _selectedPreferences,
          cuisineType: widget.cuisineType,
          onAllergiesSelected: (allergies) {
            // Handle allergies selection
            setState(() {
              // Store allergies if needed in this screen
            });
          },
        ),
      ),
    );
  }
}
