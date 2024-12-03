import 'package:flutter/material.dart';
import 'diet_selection_screen.dart';

class WelcomeSlides extends StatefulWidget {
  const WelcomeSlides({super.key});

  @override
  State<WelcomeSlides> createState() => _WelcomeSlidesState();
}

class _WelcomeSlidesState extends State<WelcomeSlides> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/welcomingslide1.png',
      'title': 'Personalized meal planning',
      'description': "Pick your week's meals in minutes. With over 200 personalization options, eat exactly how you want to eat.",
    },
    {
      'image': 'assets/images/welcomingslide2.png',
      'title': 'Simple, stress-free grocery shopping',
      'description': 'Grocery shop once per week with an organized "done for you" shopping list.',
    },
    {
      'image': 'assets/images/welcomingslide3.png',
      'title': 'Delicious, healthy meals made easy',
      'description': 'Easily cook healthy, delicious meals in about 30 minutes, from start to finish.',
    },
  ];

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
            PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    const SizedBox(height: 120),
                    Image.asset(
                      _slides[index]['image']!,
                      width: 280,
                      height: 280,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 40),
                    // Slide Indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 10,
                          height: 10,
                          decoration: ShapeDecoration(
                            color: i == _currentPage
                                ? const Color(0xFFF48600)
                                : const Color(0xFFE6E6E6),
                            shape: const OvalBorder(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            _slides[index]['title']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 24,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              letterSpacing: -1.20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _slides[index]['description']!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF666666),
                              fontSize: 16,
                              fontFamily: 'DM Sans',
                              fontWeight: FontWeight.w400,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            // Continue Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 80,
              child: GestureDetector(
                onTap: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DietSelectionScreen(),
                      ),
                    );
                  }
                },
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Skip Button
            Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: GestureDetector(
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text(
                  'Skip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
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