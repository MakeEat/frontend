import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import '../models/recipe.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screens/home_screen.dart';
import '../services/favorites_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RecipeDisplayScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeDisplayScreen({
    super.key,
    required this.recipe,
  });

  @override
  State<RecipeDisplayScreen> createState() => _RecipeDisplayScreenState();
}

class _RecipeDisplayScreenState extends State<RecipeDisplayScreen> {
  final GlobalKey _globalKey = GlobalKey();
  final FavoritesService _favoritesService = FavoritesService();
  String? generatedImageUrl;
  bool isGeneratingImage = false;
  bool isFavorite = false;
  String? localImagePath;

  Future<void> _saveRecipeAsImage() async {
    try {
      // Check if widget is mounted before proceeding
      if (!mounted) return;

      // Request storage permission
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission required to save image'))
        );
        return;
      }

      // Show loading indicator
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Capturing recipe...'))
      );

      // Wait for a brief moment to ensure the loading message is shown
      await Future.delayed(const Duration(milliseconds: 500));

      // Convert widget to image with higher quality
      RenderRepaintBoundary boundary = 
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0); // Increased pixel ratio for better quality
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: "Recipe_${widget.recipe.title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}"
        );
        
        if (!mounted) return;
        
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Recipe saved to gallery!'),
              backgroundColor: Color(0xFF33985B), // Success green color
            )
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to save image'),
              backgroundColor: Colors.red,
            )
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving image: ${e.toString()}'),
          backgroundColor: Colors.red,
        )
      );
    }
  }

  Future<void> _generateImage() async {
    setState(() => isGeneratingImage = true);
    try {
      final apiKey = dotenv.env['OPENAI_API_KEY'];
      if (apiKey == null) throw Exception('OpenAI API key not found');

      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/images/generations'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'prompt': 'Professional food photography of ${widget.recipe.title}, restaurant style plating, high resolution',
          'n': 1,
          'size': '512x512',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final imageUrl = data['data'][0]['url'];
        
        // Download and save image locally
        final imageResponse = await http.get(Uri.parse(imageUrl));
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'recipe_${widget.recipe.title.replaceAll(' ', '_')}.png';
        final localPath = '${appDir.path}/$fileName';
        
        await File(localPath).writeAsBytes(imageResponse.bodyBytes);
        
        setState(() {
          localImagePath = localPath;
          isGeneratingImage = false;
        });
        
        // Update the recipe's local image path
        widget.recipe.localImagePath = localPath;
        
        // If the recipe is already a favorite, update it in storage
        if (isFavorite) {
          await _favoritesService.toggleFavorite(widget.recipe);
          await _favoritesService.toggleFavorite(widget.recipe);
        }
      } else {
        throw Exception('Failed to generate image');
      }
    } catch (e) {
      setState(() => isGeneratingImage = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating image: $e')),
      );
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

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _loadLocalImage();
    if (widget.recipe.imageUrl.isEmpty && localImagePath == null) {
      _generateImage();
    }
  }

  Future<void> _loadFavoriteStatus() async {
    final status = await _favoritesService.isFavorite(widget.recipe);
    if (mounted) {
      setState(() {
        isFavorite = status;
      });
    }
  }

  Future<void> _loadLocalImage() async {
    if (widget.recipe.localImagePath != null) {
      setState(() {
        localImagePath = widget.recipe.localImagePath;
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
        child: RepaintBoundary( // Wrap entire content with RepaintBoundary
          key: _globalKey,
          child: Stack(
            children: [
              // Back Button and Save Button
              Positioned(
                left: 16,
                right: 16,
                top: 54,
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
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : null,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                        IconButton(
                          icon: const Icon(Icons.save),
                          onPressed: _saveRecipeAsImage,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content
              Positioned.fill(
                top: 100,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.recipe.title,
                          style: const TextStyle(
                            color: Color(0xFF191919),
                            fontSize: 32,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.60,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildRecipeImage(),
                        const SizedBox(height: 24),
                        _buildRecipeDetails(),
                        _buildIngredientsList(),
                        _buildInstructions(),
                        _buildNutritionalInfo(),
                        const SizedBox(height: 40),
                      ],
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

  Widget _buildRecipeImage() {
    if (localImagePath != null) {
      return Image.file(
        File(localImagePath!),
        width: double.infinity,
        height: 200,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error loading local image: $error');
          return _buildPlaceholderImage();
        },
      );
    }
    
    if (widget.recipe.imageUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          widget.recipe.imageUrl,
          width: double.infinity,
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildPlaceholderImage();
          },
        ),
      );
    }

    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: 200,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(
          Icons.image_not_supported,
          size: 50,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildRecipeDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFFCCCCCC)),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.description,
            style: const TextStyle(
              color: Color(0xFF666666),
              fontSize: 16,
              fontFamily: 'DM Sans',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.timer, size: 20, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                widget.recipe.cookTime,
                style: const TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 24),
              const Icon(Icons.people, size: 20, color: Color(0xFF666666)),
              const SizedBox(width: 8),
              Text(
                '${widget.recipe.servings} servings',
                style: const TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 16,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Ingredients',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 24,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.recipe.ingredients.map((ingredient) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFF48600),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  ingredient,
                  style: const TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Instructions',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 24,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        ...widget.recipe.instructions.asMap().entries.map((entry) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const ShapeDecoration(
                  color: Color(0xFFF48600),
                  shape: CircleBorder(),
                ),
                child: Center(
                  child: Text(
                    '${entry.key + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  entry.value,
                  style: const TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildNutritionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Nutritional Information',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 24,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildNutritionCard('Calories', '${widget.recipe.nutritionFacts['calories']}', 'kcal'),
              _buildNutritionCard('Protein', '${widget.recipe.nutritionFacts['protein']}', 'g'),
              _buildNutritionCard('Carbs', '${widget.recipe.nutritionFacts['carbs']}', 'g'),
              _buildNutritionCard('Fat', '${widget.recipe.nutritionFacts['fat']}', 'g'),
              _buildNutritionCard('Fiber', '${widget.recipe.nutritionFacts['fiber']}', 'g'),
              _buildNutritionCard('Sugar', '${widget.recipe.nutritionFacts['sugar']}', 'g'),
              _buildNutritionCard('Sodium', '${widget.recipe.nutritionFacts['sodium']}', 'mg'),
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