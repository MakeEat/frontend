import 'package:flutter/material.dart';

class WelcomeSlides extends StatelessWidget {
  const WelcomeSlides({super.key});

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
            // Welcome Image
            Positioned(
              left: 48,
              top: 100,
              child: Image.asset(
                'assets/images/welcomingslide1.png',
                width: 366,
                height: 366,
                fit: BoxFit.contain,
              ),
            ),
            
            // Bottom Navigation Bar
            Positioned(
              left: -1,
              top: 911,
              child: Container(
                width: 431,
                height: 21,
                padding: const EdgeInsets.symmetric(horizontal: 146),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 139,
                      height: 5,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF191919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Content
            const Positioned(
              left: 32,
              top: 577,
              child: SizedBox(
                width: 367,
                child: Column(
                  children: [
                    Text(
                      'Personalized meal planning',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 32,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                        letterSpacing: -1.60,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      "Pick your week's meals in minutes. With over 200 personalization options, eat exactly how you want to eat.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Slide Indicators
            Positioned(
              left: 182,
              top: 514,
              child: Row(
                children: [
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFF48600),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFE6E6E6),
                      shape: OvalBorder(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const ShapeDecoration(
                      color: Color(0xFFE6E6E6),
                      shape: OvalBorder(),
                    ),
                  ),
                ],
              ),
            ),
            
            // Continue Button
            Positioned(
              left: 17,
              top: 789,
              child: GestureDetector(
                onTap: () {
                  // Navigate to next slide or home screen
                },
                child: Container(
                  width: 397,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 18,
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
              left: 197,
              top: 862,
              child: GestureDetector(
                onTap: () {
                  // Navigate to home screen
                  Navigator.of(context).pushReplacementNamed('/home');
                },
                child: const Text(
                  'Skip',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
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