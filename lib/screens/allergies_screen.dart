import 'package:flutter/material.dart';
import '../utils/theme.dart';

class AllergiesScreen extends StatefulWidget {
  final List<String> allergies;
  final Function(List<String>) onAllergiesSelected;

  const AllergiesScreen({
    super.key,
    required this.allergies,
    required this.onAllergiesSelected,
  });

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
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

  late List<String> _selectedAllergies;

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
          'Select Allergies',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            widget.onAllergiesSelected(_selectedAllergies);
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _allAllergies.length,
        itemBuilder: (context, index) {
          final allergy = _allAllergies[index];
          return CheckboxListTile(
            title: Text(
              allergy,
              style: AppTextStyles.body,
            ),
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
    );
  }
}
