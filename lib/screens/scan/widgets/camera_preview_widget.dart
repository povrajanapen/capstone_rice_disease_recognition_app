import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Instruction Text (now in the back)
        Positioned(
          top: MediaQuery.of(context).size.height * 0.15,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              languageProvider.translate("Position object within frame"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        // Bordered Container with Example Image (now in front)
        Center(
          child: Container(
            width: screenWidth * 0.8,
            height: screenWidth * 1.2,
            decoration: BoxDecoration(
              border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 3.0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14), // Slightly less than container to fit border
              child: Opacity(
                opacity: 1.0, // Semi-transparent to show camera preview beneath
                child: Image.asset(
                  'assets/images/ToScanImage.png', // Example image
                  width: screenWidth * 0.8,
                  height: screenWidth * 0.8,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}