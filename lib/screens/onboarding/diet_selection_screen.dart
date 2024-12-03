import 'package:flutter/material.dart';
import 'allergies_screen.dart';
import '../../services/preferences_service.dart';
import 'package:provider/provider.dart';

class DietSelectionScreen extends StatefulWidget {
  final bool isEditing;

  const DietSelectionScreen({
    super.key,
    this.isEditing = false,
  });

  @override
  State<DietSelectionScreen> createState() => _DietSelectionScreenState();
}

class _DietSelectionScreenState extends State<DietSelectionScreen> {
  String? selectedDiet;

  final List<String> diets = [
    'Classic',
    'Low Carb',
    'Keto',
    'Paleo',
    'Vegetarian',
    'Pescetarian',
    'Vegan',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _loadSavedPreferences();
    }
  }

  Future<void> _loadSavedPreferences() async {
    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    final savedDiet = prefsService.getDiet();
    if (savedDiet != null) {
      setState(() {
        selectedDiet = savedDiet;
      });
    }
  }

  void _navigateToNext() async {
    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    if (selectedDiet != null) {
      await prefsService.saveDiet(selectedDiet!);
    }

    if (!mounted) return;

    if (widget.isEditing) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllergiesScreen(
            selectedAllergies: prefsService.getAllergies(),
            onAllergiesSelected: (allergies) async {
              await prefsService.saveAllergies(allergies);
            },
            isEditing: true,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AllergiesScreen(
            selectedAllergies: const [],
            onAllergiesSelected: (allergies) async {
              await prefsService.saveAllergies(allergies);
            },
            isEditing: false,
          ),
        ),
      );
    }
  }

  Widget _buildDietOption(String diet) {
    bool isSelected = selectedDiet == diet;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          setState(() {
            selectedDiet = diet;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: ShapeDecoration(
            color: isSelected ? const Color(0xFFFFE3C1) : Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                color: isSelected ? const Color(0xFFF48600) : const Color(0xFFCCCCCC),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            diet,
            style: TextStyle(
              color: const Color(0xFF191919),
              fontSize: 18,
              fontFamily: 'DM Sans',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        color: index == 0 
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

            // Back Button
            Positioned(
              left: 16,
              top: 54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              top: 130,
              right: 16,
              bottom: 100,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pick your diet',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 32,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.60,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ...diets.map((diet) => _buildDietOption(diet)),
                  ],
                ),
              ),
            ),

            // Continue Button
            Positioned(
              left: 17,
              bottom: 40,
              right: 17,
              child: ElevatedButton(
                onPressed: selectedDiet != null 
                    ? _navigateToNext 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    color: Colors.white,
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
} 