import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/recipe.dart';

class FavoritesService {
  static const String _key = 'favorite_recipes';
  
  Future<List<Recipe>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? recipesJson = prefs.getString(_key);
    
    if (recipesJson == null) return [];
    
    final List<dynamic> decodedList = jsonDecode(recipesJson);
    return decodedList.map((json) => Recipe.fromJson(json)).toList();
  }
  
  Future<void> toggleFavorite(Recipe recipe) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    
    final isAlreadyFavorite = favorites.any((r) => r.title == recipe.title);
    
    if (isAlreadyFavorite) {
      favorites.removeWhere((r) => r.title == recipe.title);
    } else {
      favorites.add(recipe);
    }
    
    await prefs.setString(_key, jsonEncode(favorites.map((r) => r.toJson()).toList()));
  }
  
  Future<bool> isFavorite(Recipe recipe) async {
    final favorites = await getFavorites();
    return favorites.any((r) => r.title == recipe.title);
  }
} 