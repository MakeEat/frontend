import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/receipt_analysis_service.dart';
import 'ingredient_selection_screen.dart';
import 'confirmation_screen.dart';

class IngredientsScreen extends StatefulWidget {
  final String mealType;
  final List<String> dietaryPreferences;
  final List<String> allergies;
  final String cuisineType;
  final String servingSize;
  final int targetCalories;
  final List<String>? existingIngredients;

  const IngredientsScreen({
    super.key,
    required this.mealType,
    required this.dietaryPreferences,
    required this.allergies,
    required this.cuisineType,
    required this.servingSize,
    required this.targetCalories,
    this.existingIngredients,
  });

  @override
  State<IngredientsScreen> createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final TextEditingController ingredientController = TextEditingController();
  final FocusNode ingredientFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  final ReceiptAnalysisService _receiptAnalysisService = ReceiptAnalysisService();
  List<String> ingredients = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    ingredients = widget.existingIngredients?.toList() ?? [];
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFF48600)),
                title: const Text(
                  'Take Photo',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 85,
                  );
                  if (photo != null) {
                    await _processImage(File(photo.path));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Color(0xFFF48600)),
                title: const Text(
                  'Choose from Gallery',
                  style: TextStyle(
                    fontFamily: 'DM Sans',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  final XFile? image = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 85,
                  );
                  if (image != null) {
                    await _processImage(File(image.path));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processImage(File imageFile) async {
    try {
      setState(() => isLoading = true);
      final ingredients = await _receiptAnalysisService.analyzeReceipt(imageFile);
      
      if (!mounted) return;
      
      setState(() => isLoading = false);
      
      final selectedIngredients = await Navigator.push<List<String>>(
        context,
        MaterialPageRoute(
          builder: (context) => IngredientSelectionScreen(
            detectedIngredients: ingredients,
          ),
        ),
      );

      if (selectedIngredients != null && mounted) {
        setState(() {
          this.ingredients.addAll(selectedIngredients);
        });
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

  void _addIngredient(String ingredient) {
    final trimmed = ingredient.trim();
    if (trimmed.isNotEmpty && !ingredients.contains(trimmed)) {
      setState(() {
        ingredients.add(trimmed);
        ingredientController.clear();
      });
      ingredientFocusNode.requestFocus();
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      ingredients.removeAt(index);
    });
  }

  void _navigateToConfirmation() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationScreen(
          mealType: widget.mealType,
          dietaryPreferences: widget.dietaryPreferences,
          allergies: widget.allergies,
          cuisineType: widget.cuisineType,
          servingSize: widget.servingSize,
          ingredients: ingredients,
          targetCalories: widget.targetCalories,
        ),
      ),
    );
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
            // Back Button
            Positioned(
              left: 16,
              top: 54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Main Content
            Positioned(
              left: 16,
              right: 16,
              top: 100,
              bottom: 90,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Final touch:\nWhat ingredients do you have?',
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
                      'Add ingredients you\'d like to include in your recipe',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 18,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ingredient Input
                    Container(
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: ingredientController,
                              focusNode: ingredientFocusNode,
                              decoration: const InputDecoration(
                                hintText: 'Enter an ingredient',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                              ),
                              onSubmitted: _addIngredient,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _addIngredient(ingredientController.text),
                            icon: const Icon(Icons.add_circle),
                            color: const Color(0xFFF48600),
                            iconSize: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          IconButton(
                            onPressed: _showImageOptions,
                            icon: const Icon(Icons.arrow_circle_right),
                            color: const Color(0xFFF48600),
                            iconSize: 32,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Ingredients List
                    ingredients.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Add ingredients to create\nyour perfect recipe!",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 18,
                                    fontFamily: 'DM Sans',
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: ingredients.asMap().entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: ShapeDecoration(
                                  color: const Color(0xFFFFE3C1),
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0xFFF48600),
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      entry.value,
                                      style: const TextStyle(
                                        color: Color(0xFF191919),
                                        fontSize: 18,
                                        fontFamily: 'DM Sans',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _removeIngredient(entry.key),
                                      child: const Icon(
                                        Icons.cancel,
                                        color: Color(0xFFF48600),
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                  ],
                ),
              ),
            ),

            // Generate Recipe Button
            Positioned(
              left: 16,
              right: 16,
              bottom: 40,
              child: ElevatedButton(
                onPressed: ingredients.isNotEmpty ? _navigateToConfirmation : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF48600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  '✨ Generate Recipe',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 18,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF48600)),
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
