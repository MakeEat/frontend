import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF7F6F);
  static const Color background = Colors.white;
  static const Color text = Colors.black87;
  static const Color secondaryText = Colors.black54;
}

class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.black,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: 14,
    color: AppColors.secondaryText,
  );
} 