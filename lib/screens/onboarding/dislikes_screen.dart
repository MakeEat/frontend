import 'package:flutter/material.dart';
import '../home_screen.dart';

class DislikesScreen extends StatefulWidget {
  final List<String> selectedDislikes;
  final Function(List<String>) onDislikesSelected;

  const DislikesScreen({
    super.key,
    this.selectedDislikes = const [],
    required this.onDislikesSelected,
  });

  @override
  State<DislikesScreen> createState() => _DislikesScreenState();
}

class _DislikesScreenState extends State<DislikesScreen> {
  late Set<String> _selectedDislikes;

  final List<String> _dislikes = [
    'Avocado',
    'Beets',
    'Bell Peppers',
    'Brussels Sprouts',
    'Cauliflower',
    'Eggplant',
    'Mushrooms',
    'Olives',
    'Quinoa',
    'Tofu',
    'Turnips',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDislikes = Set.from(widget.selectedDislikes);
  }

  void _toggleDislike(String dislike) {
    setState(() {
      if (_selectedDislikes.contains(dislike)) {
        _selectedDislikes.remove(dislike);
      } else {
        _selectedDislikes.add(dislike);
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
                          color: index < 3 
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
                    'How about dislikes?',
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
                      children: _dislikes.map((dislike) {
                        final isSelected = _selectedDislikes.contains(dislike);
                        return GestureDetector(
                          onTap: () => _toggleDislike(dislike),
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
                                  dislike,
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
                  onPressed: () {
                    widget.onDislikesSelected(_selectedDislikes.toList());
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false,
                    );
                  },
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