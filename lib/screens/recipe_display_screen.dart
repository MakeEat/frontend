import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;
import '../models/recipe.dart';

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

      // Convert widget to image
      RenderRepaintBoundary boundary = 
          _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData != null) {
        final result = await ImageGallerySaver.saveImage(
          byteData.buffer.asUint8List(),
          quality: 100,
          name: "Recipe_${DateTime.now().millisecondsSinceEpoch}"
        );
        
        if (!mounted) return;
        
        if (result['isSuccess']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Recipe saved to gallery!'))
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to save image'))
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving image: ${e.toString()}'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveRecipeAsImage,
          ),
        ],
      ),
      body: RepaintBoundary(
        key: _globalKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecipeImage(),
              _buildRecipeDetails(),
              _buildIngredientsList(),
              _buildInstructions(),
              _buildNutritionalInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecipeImage() {
    return widget.recipe.imageUrl.isNotEmpty
        ? Image.network(
            widget.recipe.imageUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          )
        : Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.image, size: 50),
            ),
          );
  }

  Widget _buildRecipeDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.recipe.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(widget.recipe.description),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.timer, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(widget.recipe.cookTime),
              const SizedBox(width: 16),
              Icon(Icons.people, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text('${widget.recipe.servings} servings'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...widget.recipe.ingredients.map((ingredient) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 8),
                    const SizedBox(width: 8),
                    Text(ingredient),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Instructions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          ...widget.recipe.instructions.asMap().entries.map((entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key + 1}.',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(entry.value)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildNutritionalInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nutritional Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildNutritionCard('Calories', '${widget.recipe.nutritionalInfo.calories} kcal'),
                _buildNutritionCard('Protein', '${widget.recipe.nutritionalInfo.protein}g'),
                _buildNutritionCard('Carbs', '${widget.recipe.nutritionalInfo.carbohydrates}g'),
                _buildNutritionCard('Fat', '${widget.recipe.nutritionalInfo.fat}g'),
                _buildNutritionCard('Fiber', '${widget.recipe.nutritionalInfo.fiber}g'),
                _buildNutritionCard('Sugar', '${widget.recipe.nutritionalInfo.sugar}g'),
                _buildNutritionCard('Sodium', '${widget.recipe.nutritionalInfo.sodium}mg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 