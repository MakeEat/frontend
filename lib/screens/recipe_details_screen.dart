import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/favorites_service.dart';

class RecipeDetailsScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDetailsScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDetailsScreen> createState() => _RecipeDetailsScreenState();
}

class _RecipeDetailsScreenState extends State<RecipeDetailsScreen> {
  final FavoritesService _favoritesService = FavoritesService();
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final status = await _favoritesService.isFavorite(widget.recipe);
    if (mounted) {
      setState(() {
        isFavorite = status;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    await _favoritesService.toggleFavorite(widget.recipe);
    if (mounted) {
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  Future<void> _shareRecipe(BuildContext context) async {
    // Implement share recipe functionality
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFAFAFA), Color(0xFFFFF4ED)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Back Button and Favorite Button
              Positioned(
                left: 16,
                right: 16,
                top: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: () => _shareRecipe(context),
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Recipe Content
              Positioned.fill(
                top: 80,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.recipe.title,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DM Sans',
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (widget.recipe.imageUrl.isNotEmpty || widget.recipe.generatedImageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            widget.recipe.imageUrl.isNotEmpty 
                                ? widget.recipe.imageUrl 
                                : widget.recipe.generatedImageUrl ?? '',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                          ),
                        ),
                      const SizedBox(height: 24),
                      _buildSection('Description', widget.recipe.description),
                      _buildSection('Cook Time', widget.recipe.cookTime),
                      _buildSection('Servings', '${widget.recipe.servings} servings'),
                      _buildIngredientsList(),
                      _buildInstructionsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingredients',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 8),
        ...widget.recipe.ingredients.map((ingredient) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              const Icon(Icons.fiber_manual_record, size: 8),
              const SizedBox(width: 8),
              Text(
                ingredient,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                ),
              ),
            ],
          ),
        )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildInstructionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Instructions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'DM Sans',
          ),
        ),
        const SizedBox(height: 8),
        ...widget.recipe.instructions.asMap().entries.map((entry) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFF48600),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 200,
      height: 200,
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