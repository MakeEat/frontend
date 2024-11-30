class Recipe {
  final String title;
  final String description;
  final List<String> ingredients;
  final List<String> instructions;
  final String imageUrl;
  final String cookTime;
  final String servings;
  final NutritionalInfo nutritionalInfo;

  Recipe({
    required this.title,
    required this.description,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.cookTime,
    required this.servings,
    required this.nutritionalInfo,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      imageUrl: json['imageUrl'] ?? '',
      cookTime: json['cookTime'] ?? '',
      servings: json['servings'] ?? '',
      nutritionalInfo: NutritionalInfo.fromJson(json['nutritionalInfo'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'cookTime': cookTime,
      'servings': servings,
      'nutritionalInfo': nutritionalInfo.toJson(),
    };
  }

  Recipe copyWith({
    String? title,
    String? description,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    String? cookTime,
    String? servings,
    NutritionalInfo? nutritionalInfo,
  }) {
    return Recipe(
      title: title ?? this.title,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      cookTime: cookTime ?? this.cookTime,
      servings: servings ?? this.servings,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
    );
  }
}

class NutritionalInfo {
  final int calories;
  final int protein;
  final int carbohydrates;
  final int fat;
  final int fiber;
  final int sugar;
  final int sodium;

  NutritionalInfo({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    required this.fiber,
    required this.sugar,
    required this.sodium,
  });

  factory NutritionalInfo.fromJson(Map<String, dynamic> json) {
    return NutritionalInfo(
      calories: json['calories']?.toInt() ?? 0,
      protein: json['protein']?.toInt() ?? 0,
      carbohydrates: json['carbohydrates']?.toInt() ?? 0,
      fat: json['fat']?.toInt() ?? 0,
      fiber: json['fiber']?.toInt() ?? 0,
      sugar: json['sugar']?.toInt() ?? 0,
      sodium: json['sodium']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calories': calories,
      'protein': protein,
      'carbohydrates': carbohydrates,
      'fat': fat,
      'fiber': fiber,
      'sugar': sugar,
      'sodium': sodium,
    };
  }

  NutritionalInfo copyWith({
    int? calories,
    int? protein,
    int? carbohydrates,
    int? fat,
    int? fiber,
    int? sugar,
    int? sodium,
  }) {
    return NutritionalInfo(
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbohydrates: carbohydrates ?? this.carbohydrates,
      fat: fat ?? this.fat,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      sodium: sodium ?? this.sodium,
    );
  }
} 