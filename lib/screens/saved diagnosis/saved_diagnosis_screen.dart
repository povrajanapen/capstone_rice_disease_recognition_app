import 'package:capstone_dr_rice/models/disease.dart';
import 'package:capstone_dr_rice/provider/language_provider.dart';
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
    final savedDiagnoses = context.watch<DiagnosisProvider>().savedDiagnoses;
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          languageProvider.translate("Saved Diagnoses"),
          style: RiceTextStyles.body.copyWith(color: RiceColors.neutralDark),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0, // Added for consistency with theme
      ),
      body: savedDiagnoses.isEmpty
          ? Center(
              child: Text(
                languageProvider.translate("No saved diagnoses yet"),
                style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
              ),
            )
          : ListView.builder(
              itemCount: savedDiagnoses.length,
              itemBuilder: (context, index) {
                final diagnosis = savedDiagnoses[index];

                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                    leading: diagnosis.imagePath != null
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
                    title: Text(
                      languageProvider.translate(diagnosis.disease.name),
                      style: RiceTextStyles.button.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: RiceColors.neutralDark,
                      ),
                    ),
                    subtitle: Text(
                      '${languageProvider.translate('Confidence')}: ${((diagnosis.confidence as double? ?? 0.0) * 100).toStringAsFixed(1)}%',
                      style: RiceTextStyles.label.copyWith(
                        fontSize: 14,
                        color: RiceColors.neutral,
                      ),
                    ),
                    onTap: () {
                      if (diagnosis.imagePath != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultScreen(
                              imagePath: diagnosis.imagePath,
                              result: {
                                'class': diagnosis.disease.name,
                                'confidence': diagnosis.confidence,
                              },
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(languageProvider.translate('Image not available')),
                            duration: const Duration(milliseconds: 800),
                          ),
                        );
                      }
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: RiceColors.neutral,
                      onPressed: () {
                        context.read<DiagnosisProvider>().removeDiagnosis(diagnosis.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(languageProvider.translate('Diagnosis removed')),
                            duration: const Duration(milliseconds: 800),
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