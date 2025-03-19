import 'dart:io';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/widgets/action/rice_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/saved_diagnosis_provider.dart';

class ResultScreen extends StatefulWidget {
  final String imagePath;
  final Map<String, dynamic> result;

  const ResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _userRating = 0;
  bool _isSaved = false;
  bool _isSpeaking = false;

   

  @override
  Widget build(BuildContext context) {
    final String diseaseName = widget.result['name'] as String;
    final String description = widget.result['description'] as String;
    final double accuracy = widget.result['accuracy'] as double;

   // final String diagnosisId = diseaseName.hashCode.toString(); 

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed:
                () => Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSuccessMessage(),
                      const SizedBox(height: 10),
                      _buildAccuracySection(accuracy),
                      const SizedBox(height: 15),
                      Text(diseaseName, style: RiceTextStyles.heading),
                      _buildDescriptionSection(description),
                      const SizedBox(height: 15),
                      const Divider(height: 1),
                      const SizedBox(height: 24),
                      _buildRatingSection(),
                      const SizedBox(height: 15),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  //// Image selection ////
  Widget _buildImageSection() {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: Image.file(
        File(widget.imagePath),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }


  //// Successful message widget ////
  Widget _buildSuccessMessage() {
    return Row(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFF76B947),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Text(
          "We've successfully identified the disease",
          style: RiceTextStyles.button.copyWith(
            fontSize: 13,
            color: Color(0xFF76B947),
          ),
        ),
      ],
    );
  }


  //// Accuracy widget ////
  Widget _buildAccuracySection(double accuracy) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${(accuracy * 100).toInt()}%",
          style: RiceTextStyles.body.copyWith(
            fontSize: 38,
            fontWeight: FontWeight.bold,
            color: Color(0xFF76B947),
          ),
        ),
        Text(
          "Accuracy",
          style: RiceTextStyles.button.copyWith(
            color: Color(0xFF76B947),
            fontWeight: FontWeight.w100,
          ),
        ),
      ],
    );
  }


  //// Description widget ////
  Widget _buildDescriptionSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Description",
              style: RiceTextStyles.button.copyWith(fontSize: 16),
            ),
            const SizedBox(width: 1),
            IconButton(
              icon: Icon(
                _isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                color: Color(0xFF76B947),
              ),
              onPressed: () {
                // Implement text-to-speech functionality here
                setState(() {
                  _isSpeaking = !_isSpeaking;
                });
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          description,
          style: RiceTextStyles.label.copyWith(
            fontSize: 12,
            color: Colors.black,
            height: 1.5,
          ),
        ),
      ],
    );
  }


  //// Rating widget ////
  Widget _buildRatingSection() {
    return Container(
      decoration: BoxDecoration(
        color: RiceColors.white,
        borderRadius: BorderRadius.circular(RiceSpacings.s),
        border: Border.all(color: RiceColors.neutral, width: 1.0),
      ),
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          Text(
            "Is it accurate?",
            style: RiceTextStyles.button.copyWith(color: Color(0xFF76B947)),
            textAlign: TextAlign.center,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.1),
                child: IconButton(
                  icon: Icon(
                    index < _userRating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: index < _userRating ? Colors.amber : Colors.orange,
                    size: 26,
                  ),
                  onPressed: () {
                    setState(() {
                      _userRating = index + 1;
                    });
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  //// Save button widget ////
 Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    child: RiceButton(
      icon: _isSaved ? Icons.remove_circle_outline : Icons.bookmark_outline,
      text: _isSaved ? "Remove" : "Save diagnosis",
      type: _isSaved ? RiceButtonType.secondary : RiceButtonType.primary,
      onPressed: () {
        final provider = Provider.of<SavedDiagnosisProvider>(context, listen: false);
        
        setState(() {
          _isSaved = !_isSaved;
        });

        // Get the data from the result map
        final String diseaseName = widget.result['name'] as String;
        final String description = widget.result['description'] as String;
        final double accuracy = widget.result['accuracy'] as double;
        
        // Generate a unique ID if not available
        final String diagnosisId = widget.result['id'] as String? ?? 
            DateTime.now().millisecondsSinceEpoch.toString();

        // Save or remove the diagnosis based on whether it's saved
        if (_isSaved) {
          provider.saveDiagnosis(diagnosisId, {
            'name': diseaseName,
            'description': description,
            'accuracy': accuracy,
            'imagePath': widget.imagePath, // Include the image path
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Diagnosis saved successfully')),
          );
        } else {
          provider.removeDiagnosis(diagnosisId);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Diagnosis removed from saved')),
          );
        }
        print("Diagnosis saved status: $_isSaved");
      },
    ),
  );
}
}
