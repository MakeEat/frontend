import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'allergies_screen.dart';
import 'serving_size_screen.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  final List<String> selectedPreferences;
  final List<String> selectedAllergies;
  final Function(List<String>, List<String>) onPreferencesSelected;
  final String mealType;
  final String cuisineType;

  const DietaryPreferencesScreen({
    super.key,
    required this.selectedPreferences,
    required this.selectedAllergies,
    required this.onPreferencesSelected,
    required this.mealType,
    required this.cuisineType,
  });

  @override
  State<DietaryPreferencesScreen> createState() => _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  late List<String> _selectedPreferences;
  late List<String> _selectedAllergies;

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
    _selectedAllergies = List.from(widget.selectedAllergies);
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
          onPressed: _saveAndNavigateBack,
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
                  title: Text(
                    option,
                    style: AppTextStyles.body,
                  ),
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () => _navigateToAllergies(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Manage Allergies'),
              ),
            ),
            if (_selectedAllergies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedAllergies.map((allergy) {
                    return Chip(
                      label: Text(allergy),
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      labelStyle: const TextStyle(color: AppColors.primary),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        setState(() {
                          _selectedAllergies.remove(allergy);
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _saveAndNavigateBack,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Save Preferences'),
          ),
        ),
      ),
    );
  }

  void _navigateToAllergies(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllergiesScreen(
          allergies: _selectedAllergies,
          onAllergiesSelected: (List<String> allergies) {
            setState(() {
              _selectedAllergies = allergies;
            });
          },
        ),
      ),
    );
    if (result != null) {
      setState(() {
        _selectedAllergies = result;
      });
    }
  }

  void _saveAndNavigateBack() {
    widget.onPreferencesSelected(_selectedPreferences, _selectedAllergies);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServingSizeScreen(
          mealType: widget.mealType,
          dietaryPreferences: _selectedPreferences,
          allergies: _selectedAllergies,
          cuisineType: widget.cuisineType,
        ),
      ),
    );
  }
}
