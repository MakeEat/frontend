import 'package:flutter/material.dart';
import 'all_set_screen.dart';

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
  final TextEditingController _customDislikeController = TextEditingController();

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

  void _addCustomDislike() {
    final customDislike = _customDislikeController.text.trim();
    if (customDislike.isNotEmpty) {
      setState(() {
        _selectedDislikes.add(customDislike);
        _customDislikeController.clear();
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
                    const SizedBox(height: 24),
                    const Text(
                      'How about dislikes?',
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
                      children: _dislikes.map((dislike) {
                        final isSelected = _selectedDislikes.contains(dislike);
                        return GestureDetector(
                          onTap: () => _toggleDislike(dislike),
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
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _customDislikeController,
                      decoration: InputDecoration(
                        hintText: 'Add custom dislike',
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
                      onPressed: _addCustomDislike,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF48600),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(140, 57),
                      ),
                      child: const Text(
                        'Add Dislike',
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
                  widget.onDislikesSelected(_selectedDislikes.toList());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllSetScreen(),
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