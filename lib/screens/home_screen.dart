import 'package:flutter/material.dart';
import '../models/recipe.dart';
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

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<Recipe>> mealPlan = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Your Meal Plan',
              style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 32,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
                letterSpacing: -1.60,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFCCCCCC)),
              ),
              child: Column(
                children: [
                  _buildCalendarHeader(),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSelectedDateMeals(),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => _addRecipeForDate(selectedDate),
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
                  'Add Recipe for This Day',
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
    );
  }

  Widget _buildCalendarHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => _changeMonth(-1),
        ),
        Text(
          '${_getMonthName(selectedDate.month)} ${selectedDate.year}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'DM Sans',
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => _changeMonth(1),
        ),
      ],
    );
  }

  Widget _buildCalendarGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => 
            Text(
              day,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF666666),
              ),
            ),
          ).toList(),
        ),
        const SizedBox(height: 8),
        ...List.generate(6, (weekIndex) => _buildWeekRow(weekIndex)),
      ],
    );
  }

  Widget _buildWeekRow(int weekIndex) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final firstDayWeekday = firstDayOfMonth.weekday;
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(7, (dayIndex) {
        final dayNumber = weekIndex * 7 + dayIndex - firstDayWeekday + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox(width: 36, height: 36);
        }

        final date = DateTime(selectedDate.year, selectedDate.month, dayNumber);
        final isSelected = date.year == selectedDate.year && 
                         date.month == selectedDate.month && 
                         date.day == selectedDate.day;
        final hasRecipes = mealPlan[date]?.isNotEmpty ?? false;

        return GestureDetector(
          onTap: () => setState(() => selectedDate = date),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFF48600) : Colors.transparent,
              borderRadius: BorderRadius.circular(18),
              border: hasRecipes ? Border.all(color: const Color(0xFFF48600)) : null,
            ),
            child: Center(
              child: Text(
                dayNumber.toString(),
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF191919),
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSelectedDateMeals() {
    final recipes = mealPlan[selectedDate] ?? [];
    if (recipes.isEmpty) {
      return const Center(
        child: Text(
          'No recipes planned for this day',
          style: TextStyle(
            color: Color(0xFF666666),
            fontSize: 16,
            fontFamily: 'DM Sans',
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: recipes.map((recipe) => _buildRecipeCard(recipe)).toList(),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCCCCCC)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: recipe.imageUrl.isNotEmpty || recipe.generatedImageUrl != null
              ? Image.network(
                  recipe.imageUrl.isNotEmpty 
                    ? recipe.imageUrl 
                    : recipe.generatedImageUrl ?? '',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                )
              : _buildPlaceholderImage(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'DM Sans',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe.cookTime,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      selectedDate = DateTime(selectedDate.year, selectedDate.month + delta, 1);
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  void _addRecipeForDate(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecipeAIScreen(),
      ),
    ).then((recipe) {
      if (recipe != null && recipe is Recipe) {
        setState(() {
          if (mealPlan[date] == null) {
            mealPlan[date] = [];
          }
          mealPlan[date]!.add(recipe);
        });
      }
    });
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }
}
