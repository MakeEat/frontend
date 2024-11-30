import 'package:flutter/material.dart';
import '../utils/theme.dart';

class CuisineTypeScreen extends StatefulWidget {
  final List<String> selectedCuisines;
  final Function(List<String>) onCuisinesSelected;

  const CuisineTypeScreen({
    super.key,
    required this.selectedCuisines,
    required this.onCuisinesSelected,
  });

  @override
  State<CuisineTypeScreen> createState() => _CuisineTypeScreenState();
}

class _CuisineTypeScreenState extends State<CuisineTypeScreen> {
  late List<String> _selectedCuisines;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _allCuisines = [
    'Italian', 'Chinese', 'Japanese', 'Mexican', 'Indian',
    'Thai', 'French', 'Mediterranean', 'American', 'Korean',
    'Vietnamese', 'Greek', 'Spanish', 'Middle Eastern', 'Brazilian',
    // Add more cuisines as needed
  ];

  @override
  void initState() {
    super.initState();
    _selectedCuisines = List.from(widget.selectedCuisines);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Cuisine Types',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _saveAndNavigateBack,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search cuisines...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCuisines.length,
              itemBuilder: (context, index) {
                final cuisine = _filteredCuisines[index];
                return CheckboxListTile(
                  title: Text(
                    cuisine,
                    style: AppTextStyles.body,
                  ),
                  value: _selectedCuisines.contains(cuisine),
                  activeColor: AppColors.primary,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedCuisines.add(cuisine);
                      } else {
                        _selectedCuisines.remove(cuisine);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
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
            child: const Text('Save Selections'),
          ),
        ),
      ),
    );
  }

  List<String> get _filteredCuisines {
    if (_searchQuery.isEmpty) {
      return _allCuisines;
    }
    return _allCuisines
        .where((cuisine) => cuisine.toLowerCase().contains(_searchQuery))
        .toList();
  }

  void _saveAndNavigateBack() {
    widget.onCuisinesSelected(_selectedCuisines);
  }
}