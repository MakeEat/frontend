import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/recipe.dart';
import '../widgets/recipe_placeholder.dart';
import './recipe_display_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesService _favoritesService = FavoritesService();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFFFF4ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FutureBuilder<List<Recipe>>(
            future: _favoritesService.getFavorites(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final recipes = snapshot.data ?? [];

              if (recipes.isEmpty) {
                return _buildEmptyState();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'Your Favorite Recipes',
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 32,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.60,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.83,
                      ),
                      itemCount: recipes.length,
                      itemBuilder: (context, index) {
                        final recipe = recipes[index];
                        return Dismissible(
                          key: Key(recipe.title),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            alignment: Alignment.center,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) async {
                            await _favoritesService.toggleFavorite(recipe);
                            setState(() {});
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RecipeDisplayScreen(
                                    recipe: recipe,
                                  ),
                                ),
                              );
                            },
                            child: SizedBox(
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: recipe.imageUrl.isNotEmpty || recipe.generatedImageUrl != null
                                            ? Image.network(
                                                recipe.imageUrl.isNotEmpty 
                                                  ? recipe.imageUrl 
                                                  : recipe.generatedImageUrl ?? '',
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                                              )
                                            : _buildPlaceholderImage(),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        recipe.title,
                                        style: const TextStyle(
                                          color: Color(0xFF191919),
                                          fontSize: 14,
                                          fontFamily: 'DM Sans',
                                          fontWeight: FontWeight.w700,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                        onPressed: () async {
                                          final shouldRemove = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              elevation: 0,
                                              backgroundColor: Colors.transparent,
                                              child: Container(
                                                padding: const EdgeInsets.all(24),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black.withOpacity(0.1),
                                                      blurRadius: 20,
                                                      offset: const Offset(0, 10),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      padding: const EdgeInsets.all(16),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFFFF4ED),
                                                        borderRadius: BorderRadius.circular(50),
                                                      ),
                                                      child: const Icon(
                                                        Icons.favorite,
                                                        color: Color(0xFFF48600),
                                                        size: 32,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24),
                                                    const Text(
                                                      'Remove from Favorites',
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight: FontWeight.w700,
                                                        fontFamily: 'DM Sans',
                                                        color: Color(0xFF191919),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    const Text(
                                                      'Are you sure you want to remove this recipe from your favorites?',
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xFF666666),
                                                        fontFamily: 'DM Sans',
                                                      ),
                                                    ),
                                                    const SizedBox(height: 32),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () => Navigator.pop(context, false),
                                                            style: TextButton.styleFrom(
                                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                                side: const BorderSide(
                                                                  color: Color(0xFFF48600),
                                                                ),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Cancel',
                                                              style: TextStyle(
                                                                color: Color(0xFFF48600),
                                                                fontSize: 16,
                                                                fontFamily: 'DM Sans',
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Expanded(
                                                          child: TextButton(
                                                            onPressed: () => Navigator.pop(context, true),
                                                            style: TextButton.styleFrom(
                                                              padding: const EdgeInsets.symmetric(vertical: 16),
                                                              backgroundColor: const Color(0xFFF48600),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(12),
                                                              ),
                                                            ),
                                                            child: const Text(
                                                              'Remove',
                                                              style: TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontFamily: 'DM Sans',
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );

                                          if (shouldRemove == true) {
                                            await _favoritesService.toggleFavorite(recipe);
                                            if (mounted) {
                                              setState(() {});
                                            }
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(
                                          minWidth: 32,
                                          minHeight: 32,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFAFAFA), Color(0xFFFFF4ED)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Your Favorite Recipes',
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
                  'Save your favorite recipes here for quick access. Start by exploring and saving recipes you love!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                Image.asset(
                  'assets/images/nofavslogo.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () {
                    // Navigate to recipe creation or discovery
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
                      'Discover Recipes',
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
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return const RecipePlaceholderImage(
      width: 160,
      height: 160,
    );
  }

  Widget _buildNutritionalInfo(Recipe recipe) {
    final nutritionFacts = recipe.nutritionFacts;
    
    final caloriesPerServing = nutritionFacts['calories'] ?? 0;
    final proteinPerServing = nutritionFacts['protein'] ?? 0;
    final carbsPerServing = nutritionFacts['carbs'] ?? 0;
    final fatPerServing = nutritionFacts['fat'] ?? 0;
    final fiberPerServing = nutritionFacts['fiber'] ?? 0;
    final sugarPerServing = nutritionFacts['sugar'] ?? 0;
    final sodiumPerServing = nutritionFacts['sodium'] ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              'Nutritional Information',
              style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 24,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '(total calories)',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 16,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildNutritionCard('Calories', '$caloriesPerServing', 'kcal'),
              const SizedBox(width: 8),
              _buildNutritionCard('Protein', '$proteinPerServing', 'g'),
              const SizedBox(width: 8),
              _buildNutritionCard('Carbs', '$carbsPerServing', 'g'),
              const SizedBox(width: 8),
              _buildNutritionCard('Fat', '$fatPerServing', 'g'),
              const SizedBox(width: 8),
              _buildNutritionCard('Fiber', '$fiberPerServing', 'g'),
              const SizedBox(width: 8),
              _buildNutritionCard('Sugar', '$sugarPerServing', 'g'),
              const SizedBox(width: 8),
              _buildNutritionCard('Sodium', '$sodiumPerServing', 'mg'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNutritionCard(String label, String value, String unit) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 14,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$value$unit',
            style: const TextStyle(
              color: Color(0xFFF48600),
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
} 