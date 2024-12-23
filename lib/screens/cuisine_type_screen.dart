import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/preferences_service.dart';
import 'serving_size_screen.dart';
import 'package:intl/intl.dart';

class CuisineTypeScreen extends StatefulWidget {
  final List<String> selectedCuisines;
  final Function(List<String>) onCuisinesSelected;
  final String mealType;

  const CuisineTypeScreen({
    super.key,
    required this.selectedCuisines,
    required this.onCuisinesSelected,
    required this.mealType,
  });

  @override
  State<CuisineTypeScreen> createState() => _CuisineTypeScreenState();
}

class _CuisineTypeScreenState extends State<CuisineTypeScreen> {
  late List<String> _selectedCuisines;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late String _currentMealType;

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
    _currentMealType = _determineMealType();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAF5), Color(0xFFFFE3C1)],
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
              right: 16,
              child: Row(
                children: List.generate(5, (index) {
                  return Expanded(
                    child: Container(
                      height: 12,
                      margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                      decoration: ShapeDecoration(
                        color: index < 2 
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

            // Main Content
            Positioned(
              left: 16,
              right: 16,
              top: 130,
              bottom: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select cuisines',
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
                    'Choose your preferred cuisine types for $_currentMealType',
                    style: const TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 16,
                      fontFamily: 'DM Sans',
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Search TextField with rounded corners and icon
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search cuisines...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF777777)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFF48600)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  // Cuisines Grid
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: _filteredCuisines.length,
                      itemBuilder: (context, index) {
                        final cuisine = _filteredCuisines[index];
                        final isSelected = _selectedCuisines.contains(cuisine);
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedCuisines.remove(cuisine);
                              } else {
                                _selectedCuisines.add(cuisine);
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFFFE3C1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? const Color(0xFFF48600) : const Color(0xFFCCCCCC),
                              ),
                              boxShadow: isSelected ? [
                                BoxShadow(
                                  color: const Color(0xFFF48600).withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ] : null,
                            ),
                            child: Stack(
                              children: [
                                if (isSelected)
                                  Positioned(
                                    right: 8,
                                    top: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF48600),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                Center(
                                  child: Text(
                                    cuisine,
                                    style: TextStyle(
                                      color: const Color(0xFF191919),
                                      fontSize: 18,
                                      fontFamily: 'DM Sans',
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Continue Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: ElevatedButton(
                onPressed: _selectedCuisines.isNotEmpty ? _saveAndNavigateNext : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  disabledBackgroundColor: const Color(0xFFCCCCCC),
                ),
                child: Text(
                  'Continue with ${_selectedCuisines.length} ${_selectedCuisines.length == 1 ? 'cuisine' : 'cuisines'}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
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

  void _saveAndNavigateNext() async {
    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    
    // Get saved preferences
    final savedDiet = prefsService.getDiet();
    final savedAllergies = prefsService.getAllergies();
    
    // Create dietary preferences list from saved diet
    List<String> dietaryPreferences = [];
    if (savedDiet != null && savedDiet != 'Classic') {
      dietaryPreferences.add(savedDiet);
    }

    widget.onCuisinesSelected(_selectedCuisines);
    
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServingSizeScreen(
          mealType: widget.mealType,
          dietaryPreferences: dietaryPreferences,
          allergies: savedAllergies,
          cuisineType: _selectedCuisines.isNotEmpty ? _selectedCuisines.first : '',
        ),
      ),
    );
  }

  String _determineMealType() {
    // Get the current time from the device
    final now = DateTime.now();
    final currentTime = DateFormat('HH:mm').format(now);
    final hour = now.hour;

    print('Current time: $currentTime');

    // Determine meal type based on time ranges
    if (hour >= 5 && hour < 11) {
      return 'Breakfast';
    } else if (hour >= 11 && hour < 17) {
      return 'Lunch';
    } else {
      return 'Dinner';
    }
  }
}
