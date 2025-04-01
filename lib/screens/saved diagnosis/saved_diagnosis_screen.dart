import 'package:capstone_dr_rice/models/disease.dart';
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
    List<Diagnose> savedDiagnoses = context.watch<DiagnosisProvider>().savedDiagnoses;
    print(savedDiagnoses);

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

                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(
                      horizontal: RiceSpacings.s,
                      vertical: RiceSpacings.s,
                    ),
                    decoration: BoxDecoration(
                      color: RiceColors.backgroundAccent,
                      borderRadius: BorderRadius.circular(RiceSpacings.s),
                      border: Border.all(color: RiceColors.neutral, width: 0.5),
                    ),
                    child: ListTile(
                      // Disease image
                      leading:
                          diagnosis.imagePath != null
                              ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(diagnosis.imagePath),
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
                      

                      // Disease name
                      title: Text(
                        diagnosis.disease.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Text(
                        'Confidence: ${((diagnosis.confidence as double? ?? 0.0) * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        if (diagnosis.imagePath != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ResultScreen(
                                    imagePath: diagnosis.imagePath,
                                    result: {
                                      'class':
                                          diagnosis.disease.name, // Changed to 'class' to match ResultScreen
                                      'confidence': diagnosis.confidence,
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
                        color: Colors.grey,
                        onPressed: () {
                          context.read<DiagnosisProvider>().removeDiagnosis(
                            diagnosis.id,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Diagnosis removed'),
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
