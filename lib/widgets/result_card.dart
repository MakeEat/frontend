import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String recipe;

  const ResultCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Copy to Clipboard or Save feature coming soon!')),
                );
              },
              child: const Text('Save or Copy'),
            ),
          ],
        ),
      ),
    );
  }
}
