import 'package:capstone_dr_rice/repository/data_storage.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';

class DiagnosisProvider with ChangeNotifier {
  List<Map<String, dynamic>> _savedDiagnoses = [];

  List<Map<String, dynamic>> get savedDiagnoses => _savedDiagnoses;

  DiagnosisProvider() {
    _loadDiagnoses();
  }

  Future<void> _loadDiagnoses() async {
    final diagnoses = await DiagnosesStorage.loadDiagnoses();
    _savedDiagnoses =
        diagnoses
            .map(
              (diagnose) => {
                'id': diagnose.id,
                'name': diagnose.disease.name,
                'description': diagnose.disease.description,
                'accuracy': diagnose.confidence,
                'imagePath': diagnose.imagePath,
              },
            )
            .toList();
    notifyListeners();
  }

  void addDiagnosis(Diagnose diagnose, String imagePath) async {
    await DiagnosesStorage.addDiagnosis(diagnose, imagePath);
    await _loadDiagnoses(); // Reload to sync with storage
  }

  void removeDiagnosis(String? id) async {
    if (id == null) return;
    final diagnoses = await DiagnosesStorage.loadDiagnoses();
    diagnoses.removeWhere((d) => d.id == id);
    await DiagnosesStorage.saveDiagnoses(diagnoses);
    await _loadDiagnoses(); // Reload to sync with storage
  }
}
