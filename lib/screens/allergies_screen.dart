import 'package:flutter/material.dart';
import '../utils/theme.dart';
import 'serving_size_screen.dart';

class AllergiesScreen extends StatefulWidget {
  final List<String> allergies;
  final String mealType;
  final List<String> dietaryPreferences;
  final String cuisineType;
  final Function(List<String>) onAllergiesSelected;

  const AllergiesScreen({
    super.key,
    required this.allergies,
    required this.mealType,
    required this.dietaryPreferences,
    required this.cuisineType,
    required this.onAllergiesSelected,
  });

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  late List<String> _selectedAllergies;

  final List<String> _allAllergies = [
    'Dairy',
    'Eggs',
    'Fish',
    'Shellfish',
    'Tree Nuts',
    'Peanuts',
    'Wheat',
    'Soy',
    'None',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAllergies = List.from(widget.allergies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Allergies',
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
                'Select Your Allergies',
                style: AppTextStyles.heading,
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _allAllergies.length,
              itemBuilder: (context, index) {
                final allergy = _allAllergies[index];
                return CheckboxListTile(
                  title: Text(allergy),
                  value: _selectedAllergies.contains(allergy),
                  activeColor: AppColors.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        if (allergy == 'None') {
                          _selectedAllergies.clear();
                        } else {
                          _selectedAllergies.remove('None');
                        }
                        _selectedAllergies.add(allergy);
                      } else {
                        _selectedAllergies.remove(allergy);
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
            onPressed: _navigateToServingSize,
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

  void _navigateToServingSize() {
    widget.onAllergiesSelected(_selectedAllergies);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServingSizeScreen(
          mealType: widget.mealType,
          dietaryPreferences: widget.dietaryPreferences,
          allergies: _selectedAllergies,
          cuisineType: widget.cuisineType,
        ),
      ),
    );
  }
}
