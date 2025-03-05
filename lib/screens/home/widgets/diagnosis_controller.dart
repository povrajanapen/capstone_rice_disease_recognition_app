// lib/controllers/diagnosis_controller.dart
import 'package:capstone_dr_rice/screens/diagnosis/diagnosis_screen.dart';
import 'package:flutter/material.dart';

import '../../../models/diagnosis_model.dart';
import '../../../service/diagnosis_service.dart';


class DiagnosisController {
  final DiagnosisService _diagnosisService;

  DiagnosisController({
    required DiagnosisService diagnosisService,
  }) : _diagnosisService = diagnosisService;

  // Get recent diagnoses
  Future<List<DiagnosisModel>> getRecentDiagnoses() async {
    return await _diagnosisService.getRecentDiagnoses();
  }

  // Navigate to diagnosis details
  void navigateToDiagnosisDetails(BuildContext context, DiagnosisModel diagnosis) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiagnosisScreen(diagnosis: diagnosis),
      ),
    );
  }

 // Show diagnosis options
//   void showDiagnosisOptions(BuildContext context, DiagnosisModel diagnosis) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => DiagnosisOptionsSheet(
//         diagnosis: diagnosis,
//         onSave: () => _toggleSaveDiagnosis(diagnosis),
//         onDelete: () => _deleteDiagnosis(context, diagnosis),
//         onShare: () => _shareDiagnosis(diagnosis),
//       ),
//     );
//   }

//  // Toggle save diagnosis
//   Future<void> _toggleSaveDiagnosis(DiagnosisModel diagnosis) async {
//     await _diagnosisService.toggleSaveDiagnosis(diagnosis);
//   }

//   // Delete diagnosis
//   Future<void> _deleteDiagnosis(BuildContext context, DiagnosisModel diagnosis) async {
//     // Show confirmation dialog
//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Delete Diagnosis'),
//         content: const Text('Are you sure you want to delete this diagnosis?'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Delete'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed == true) {
//       await _diagnosisService.deleteDiagnosis(diagnosis.id);
//       Navigator.pop(context); // Close bottom sheet
//     }
//   }

//  // Share diagnosis
//   void _shareDiagnosis(DiagnosisModel diagnosis) {
//     // Implement share functionality
//   }
}