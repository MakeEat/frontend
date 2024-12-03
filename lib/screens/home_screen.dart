import 'package:flutter/material.dart';
import 'recipe_ai_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  static const List<Widget> _screens = [
    _HomeContent(),
    RecipeAIScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF5),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Your personalized meal plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 32,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w700,
                  letterSpacing: -1.60,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Plan your meals for the entire week in minutes. Build your first meal plan to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 18,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecipeAIScreen(),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 57,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF48600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Build Your First Meal Plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF191919),
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
      ),
    );
  }
}
