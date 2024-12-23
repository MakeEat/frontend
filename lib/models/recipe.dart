class Recipe {
  final String id;
  final String title;
  final String description;
  final String mealType;
  final String cuisineType;
  final List<String> dietaryRestrictions;
  final List<String> allergies;
  final int servings;
  final int calorieLimit;
  final List<String> ingredients;
  final List<String> instructions;
  final String cookTime;
  final String skillLevel;
  final Map<String, dynamic> nutritionFacts;
  final String imageUrl;
  String? generatedImageUrl;
  String? localImagePath;

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.mealType,
    required this.cuisineType,
    required this.dietaryRestrictions,
    required this.allergies,
    required this.servings,
    required this.calorieLimit,
    required this.ingredients,
    required this.instructions,
    required this.cookTime,
    required this.skillLevel,
    required this.nutritionFacts,
    this.imageUrl = '',
    this.generatedImageUrl,
    this.localImagePath,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      mealType: json['mealType'] ?? '',
      cuisineType: json['cuisineType'] ?? '',
      dietaryRestrictions: List<String>.from(json['dietaryRestrictions'] ?? []),
      allergies: List<String>.from(json['allergies'] ?? []),
      servings: json['servings'] is String ? int.parse(json['servings']) : (json['servings'] ?? 1),
      calorieLimit: json['calorieLimit'] is String ? int.parse(json['calorieLimit']) : (json['calorieLimit'] ?? 0),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: List<String>.from(json['instructions'] ?? []),
      cookTime: json['cookingTime']?.toString() ?? '30 minutes',
      skillLevel: json['skillLevel'] ?? 'Intermediate',
      nutritionFacts: Map<String, dynamic>.from(json['nutritionFacts'] ?? {
        'calories': 0,
        'protein': 0,
        'carbs': 0,
        'fat': 0,
        'fiber': 0,
        'sugar': 0,
        'sodium': 0,
      }),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'mealType': mealType,
      'cuisineType': cuisineType,
      'dietaryRestrictions': dietaryRestrictions,
      'allergies': allergies,
      'servings': servings,
      'calorieLimit': calorieLimit,
      'ingredients': ingredients,
      'instructions': instructions,
      'cookTime': cookTime,
      'skillLevel': skillLevel,
      'nutritionFacts': nutritionFacts,
      'imageUrl': imageUrl,
      'generatedImageUrl': generatedImageUrl,
      'localImagePath': localImagePath,
    };
  }

  Recipe copyWith({
    String? id,
    String? title,
    String? description,
    String? mealType,
    String? cuisineType,
    List<String>? dietaryRestrictions,
    List<String>? allergies,
    int? servings,
    int? calorieLimit,
    List<String>? ingredients,
    List<String>? instructions,
    String? cookTime,
    String? skillLevel,
    Map<String, dynamic>? nutritionFacts,
    String? imageUrl,
    String? generatedImageUrl,
    String? localImagePath,
  }) {
    return Recipe(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      mealType: mealType ?? this.mealType,
      cuisineType: cuisineType ?? this.cuisineType,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      allergies: allergies ?? this.allergies,
      servings: servings ?? this.servings,
      calorieLimit: calorieLimit ?? this.calorieLimit,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      cookTime: cookTime ?? this.cookTime,
      skillLevel: skillLevel ?? this.skillLevel,
      nutritionFacts: nutritionFacts ?? this.nutritionFacts,
      imageUrl: imageUrl ?? this.imageUrl,
      generatedImageUrl: generatedImageUrl ?? this.generatedImageUrl,
      localImagePath: localImagePath ?? this.localImagePath,
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