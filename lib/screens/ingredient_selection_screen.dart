import 'package:flutter/material.dart';

class IngredientSelectionScreen extends StatefulWidget {
  final List<String> detectedIngredients;
  
  const IngredientSelectionScreen({
    super.key,
    required this.detectedIngredients,
  });

  @override
  State<IngredientSelectionScreen> createState() => _IngredientSelectionScreenState();
}

class _IngredientSelectionScreenState extends State<IngredientSelectionScreen> {
  final Set<String> selectedIngredients = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFAF5), Color(0xFFFFE3C1)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Select Ingredients',
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'DM Sans',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Instructions
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Select the ingredients you want to include in your recipe:',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontFamily: 'DM Sans',
                  ),
                ),
              ),
              
              // Ingredients List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: widget.detectedIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = widget.detectedIngredients[index];
                    final isSelected = selectedIngredients.contains(ingredient);
                    
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedIngredients.add(ingredient);
                            } else {
                              selectedIngredients.remove(ingredient);
                            }
                          });
                        },
                        title: Text(
                          ingredient,
                          style: const TextStyle(
                            fontFamily: 'DM Sans',
                            fontSize: 16,
                          ),
                        ),
                        activeColor: const Color(0xFFF48600),
                        checkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Continue Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: selectedIngredients.isNotEmpty
                      ? () => Navigator.pop(context, selectedIngredients.toList())
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF48600),
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
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
      ),
    );
  }
} 