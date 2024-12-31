import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'ingredient_selection_screen.dart';
import '../services/receipt_analysis_service.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  final ImagePicker _picker = ImagePicker();
  final ReceiptAnalysisService _receiptAnalysisService = ReceiptAnalysisService();
  File? _image;
  bool isLoading = false;

  Future<void> _processImage(File image) async {
    try {
      setState(() {
        isLoading = true;
      });

      final ingredients = await _receiptAnalysisService.analyzeReceipt(image);

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
        Navigator.pop(context, selectedIngredients);
      }
    } catch (e) {
      setState(() => isLoading = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing image: $e')),
      );
    }
  }

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
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCameraButton(),
                  const SizedBox(height: 20),
                  _buildGalleryButton(),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF48600)),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraButton() {
    return _buildOptionButton(
      icon: Icons.camera_alt,
      label: 'Take Photo',
      onTap: () async {
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
        if (photo != null) {
          await _processImage(File(photo.path));
        }
      },
    );
  }

  Widget _buildGalleryButton() {
    return _buildOptionButton(
      icon: Icons.photo_library,
      label: 'Choose from Gallery',
      onTap: () async {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          await _processImage(File(image.path));
        }
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFFF48600)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: const Color(0xFFF48600)),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF191919),
                fontSize: 16,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 