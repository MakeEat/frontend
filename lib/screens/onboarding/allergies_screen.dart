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

  Future<void> _navigateToNext() async {
    widget.onAllergiesSelected(_selectedAllergies.toList());
    
    if (!mounted) return;

    final prefsService = Provider.of<PreferencesService>(context, listen: false);
    List<String> existingDislikes = [];
    
    if (widget.isEditing) {
      existingDislikes = prefsService.getDislikes();
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DislikesScreen(
          selectedDislikes: existingDislikes,
          onDislikesSelected: (dislikes) async {
            if (!mounted) return;
            
            final prefsService = Provider.of<PreferencesService>(context, listen: false);
            await prefsService.saveDislikes(dislikes);
            
            if (!mounted) return;
            
            if (widget.isEditing) {
              Navigator.of(context).popUntil((route) => route.isFirst);
            }
          },
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 430,
        height: 932,
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
            ),

            // Main Content
            Positioned(
              left: 16,
              top: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Any allergies?',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.04,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 398,
                    child: Wrap(
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
                            clipBehavior: Clip.antiAlias,
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
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
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Continue Button
            Positioned(
              left: 17,
              bottom: 40,
              child: SizedBox(
                width: 397,
                height: 57,
                child: ElevatedButton(
                  onPressed: _navigateToNext,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 18,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      height: 0.08,
                    ),
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