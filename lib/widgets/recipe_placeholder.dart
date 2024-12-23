import 'package:flutter/material.dart';

class RecipePlaceholderImage extends StatelessWidget {
  final double width;
  final double height;

  const RecipePlaceholderImage({
    super.key,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF4ED),
            Color(0xFFFFE4D2),
            Color(0xFFFFD4B8),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: height * 0.25,
          color: Colors.white.withOpacity(0.7),
        ),
      ),
    );
  }
} 