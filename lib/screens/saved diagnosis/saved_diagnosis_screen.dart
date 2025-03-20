import 'package:capstone_dr_rice/provider/saved_diagnosis_provider.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../scan/result_screen.dart';

class SaveScreen extends StatelessWidget {
  const SaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the saved diagnoses from provider
    final savedDiagnoses = context.watch<DiagnosisProvider>().savedDiagnoses;

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

                  final String diagnosisId =
                      diagnosis['id'] as String? ??
                      DateTime.now().millisecondsSinceEpoch.toString();
                  //// Save disease tiles
                  return Container(
                    //color: RiceColors.backgroundAccent,
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(
                      horizontal: RiceSpacings.s,
                      vertical: RiceSpacings.l,
                    ),
                    decoration: BoxDecoration(
                      color: RiceColors.backgroundAccent,
                      borderRadius: BorderRadius.circular(RiceSpacings.s),
                      border: Border.all(color: RiceColors.neutral, width: 0.5),
                    ),

                    child: ListTile(
                      //// disease image
                      leading:
                          diagnosis['imagePath'] != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  RiceSpacings.s,
                                ),
                                child: Image.file(
                                  File(diagnosis['imagePath']),
                                  width: 85,
                                  height: 85,
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
                      title: Text(
                        diagnosis['name'] ?? 'Unknown Disease',
                        style: RiceTextStyles.button,
                      ),
                      subtitle: Text(
                        'Accuracy: ${((diagnosis['accuracy'] ?? 0.0) * 100).toInt()}%',
                        style: RiceTextStyles.button.copyWith(
                          fontSize: 15,
                          color: RiceColors.neutral,
                        ),
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
                                      'id': diagnosisId,
                                    },
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image not available'),
                              duration: Duration(milliseconds: 800),
                            ),
                          );
                        }
                      },
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          // Handle delete functionality
                          context.read<DiagnosisProvider>().removeDiagnosis(
                            diagnosis['id'],
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Diagnosis removed'),
                            duration: Duration(milliseconds: 800),
                            ),
                            
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
