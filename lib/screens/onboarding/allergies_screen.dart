import 'package:flutter/material.dart';
import 'dislikes_screen.dart';
import 'package:provider/provider.dart';
import '../../services/preferences_service.dart';

class AllergiesScreen extends StatefulWidget {
  final List<String> selectedAllergies;
  final Function(List<String>) onAllergiesSelected;
  final bool isEditing;

  const AllergiesScreen({
    super.key,
    this.selectedAllergies = const [],
    required this.onAllergiesSelected,
    this.isEditing = false,
  });

  @override
  State<AllergiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends State<AllergiesScreen> {
  late Set<String> _selectedAllergies;
  final TextEditingController _customAllergyController = TextEditingController();

  final List<String> _allergies = [
    'Gluten',
    'Soy',
    'Sulfite',
    'Sesame',
    'Nightshade',
    'Peanut',
    'Mustard',
    'Tree Nut',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAllergies = Set.from(widget.selectedAllergies);
    if (widget.isEditing) {
      _loadSavedAllergies();
    }
  }

  Future<void> _loadSavedAllergies() async {
    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    final savedAllergies = prefsService.getAllergies();
    if (savedAllergies.isNotEmpty) {
      setState(() {
        _selectedAllergies = Set.from(savedAllergies);
      });
    }
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
      } else {
        _selectedAllergies.add(allergy);
      }
    });
  }

  void _addCustomAllergy() {
    final customAllergy = _customAllergyController.text.trim();
    if (customAllergy.isNotEmpty) {
      setState(() {
        _selectedAllergies.add(customAllergy);
        _customAllergyController.clear();
      });
    }
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
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 54),
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 20),
                    // Progress indicators
                    Row(
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
                    const SizedBox(height: 24),
                    const Text(
                      'Any allergies?',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 32,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1.60,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _allergies.map((allergy) {
                        final isSelected = _selectedAllergies.contains(allergy);
                        return GestureDetector(
                          onTap: () => _toggleAllergy(allergy),
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
                                allergy,
                                style: const TextStyle(
                                  color: Color(0xFF191919),
                                  fontSize: 18,
                                  fontFamily: 'DM Sans',
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _customAllergyController,
                      decoration: InputDecoration(
                        hintText: 'Add custom allergy',
                        hintStyle: const TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Color(0xFFF48600)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _addCustomAllergy,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(140, 57),
                      ),
                      child: const Text(
                        'Add Allergy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontFamily: 'DM Sans',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: ElevatedButton(
                onPressed: () {
                  widget.onAllergiesSelected(_selectedAllergies.toList());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DislikesScreen(
                        selectedDislikes: const [],
                        onDislikesSelected: (dislikes) {},
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  minimumSize: const Size(double.infinity, 57),
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