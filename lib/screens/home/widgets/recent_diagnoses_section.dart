
import 'package:capstone_dr_rice/theme/theme.dart';
import 'package:flutter/material.dart';

import '../../../models/diagnosis_model.dart';
import 'diagnosis_controller.dart';
import 'diagnosis_list_item.dart';

class RecentDiagnosesSection extends StatelessWidget {
  final List<DiagnosisModel> diagnoses;
  final DiagnosisController controller;

  const RecentDiagnosesSection({
    Key? key,
    required this.diagnoses,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: RiceColors.neutralLighter,
        borderRadius: BorderRadius.circular(RiceSpacings.radiusLarge),
        border: Border.fromBorderSide(BorderSide(color: RiceColors.neutral, width: 0.5)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Diagnose',
            style: RiceTextStyles.body
          ),
          const SizedBox(height: 16),
          ...diagnoses.map((diagnosis) => DiagnosisListItem(
            diagnosis: diagnosis,
            onTap: () => controller.navigateToDiagnosisDetails(context, diagnosis),
            onMoreTap: () => {},
            //controller.showDiagnosisOptions(context, diagnosis)
          )),
        ],
      ),
    );
  }}



  