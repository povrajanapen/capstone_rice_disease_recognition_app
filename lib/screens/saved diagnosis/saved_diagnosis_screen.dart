import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../provider/saved_diagnosis_provider.dart';
import '../scan/result_screen.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the saved diagnoses from provider
    final savedDiagnoses =
        context.watch<SavedDiagnosisProvider>().savedDiagnoses;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Saved Diagnoses",
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: Colors.transparent,
      ),
      body:
          savedDiagnoses.isEmpty
              ? const Center(child: Text("No saved diagnoses yet!"))
              : ListView.builder(
                itemCount: savedDiagnoses.length,
                itemBuilder: (context, index) {
                  final diagnosis = savedDiagnoses[index];
                  return ListTile(
                    //// disease image
                    leading:
                        diagnosis['imagePath'] != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(diagnosis['imagePath']),
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 24,
                                    ),
                                  );
                                },
                              ),
                            )
                            : const Icon(Icons.image_not_supported),

                    //// disease name
                    title: Text(diagnosis['name'] ?? 'Unknown Disease'),
                    subtitle: Text(
                      'Accuracy: ${((diagnosis['accuracy'] ?? 0.0) * 100).toInt()}%',
                    ),
                    onTap: () {
                      // Navigate to the ResultScreen with the selected diagnosis
                      if (diagnosis['imagePath'] != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ResultScreen(
                                  imagePath: diagnosis['imagePath'],
                                  result: {
                                    'name': diagnosis['name'],
                                    'description': diagnosis['description'],
                                    'accuracy': diagnosis['accuracy'],
                                    'id': diagnosis['id'], // Pass the ID back
                                  },
                                ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Image not available')),
                        );
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        // Handle delete functionality
                        context.read<SavedDiagnosisProvider>().removeDiagnosis(
                          diagnosis['id'],
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Diagnosis removed')),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
