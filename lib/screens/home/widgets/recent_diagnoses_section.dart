import 'package:capstone_dr_rice/provider/language_provider.dart';
import 'package:capstone_dr_rice/screens/saved%20diagnosis/diagnose_detail_screen.dart';
import 'package:capstone_dr_rice/screens/scan/result_screen.dart';
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:capstone_dr_rice/provider/saved_diagnosis_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'diagnosis_controller.dart';
import 'diagnosis_list_item.dart';

class RecentDiagnosesSection extends StatelessWidget {
  final DiagnosisController controller;

  const RecentDiagnosesSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final recentDiagnoses = context.watch<DiagnosisProvider>().getRecentDiagnoses();
    final LanguageProvider languageProvider = Provider.of<LanguageProvider>(context);

    return recentDiagnoses.isEmpty
        ? Center(
            child: Text(
              languageProvider.translate('No recent Diagnoses'),
               style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              color: RiceColors.neutralLighter,
              borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
              border: Border.fromBorderSide(
                BorderSide(color: RiceColors.neutral, width: 0.5),
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 1),
                Text(
                  languageProvider.translate('Recent Diagnoses'),
                  style: RiceTextStyles.label.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: RiceTextStyles.body.fontSize,
                  ),
                ),
                ...recentDiagnoses.map(
                  (diagnosis) => DiagnosisListItem(
                    diagnosis: diagnosis,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DiagnoseDetailScreen(
                            imagePath: diagnosis.imagePath,
                            result: {
                              'class': diagnosis.disease.name,
                              'confidence': diagnosis.confidence,
                            },
                          ),
                        ),
                      ),
                    },
                    onMoreTap: () => {}, languageProvider: languageProvider,
                  ),
                ),
              ],
            ),
          );
  }
}
