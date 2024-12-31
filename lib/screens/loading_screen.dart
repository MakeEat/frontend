import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/taco-truck.gif', // Make sure to add this GIF to your assets
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            const Text(
              'Cooking up your recipe...',
              style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 24,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 