import 'package:flutter/material.dart';

class SavedDiagnosisProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _savedDiagnoses = [];

  // Getter to fetch saved diagnoses
  List<Map<String, dynamic>> get savedDiagnoses => _savedDiagnoses;

  // Add diagnosis to the saved list
  void saveDiagnosis(String diagnosisId, Map<String, dynamic> diagnosis) {
    // Check if the diagnosis is already saved
    final index = _savedDiagnoses.indexWhere((item) => item['id'] == diagnosisId);

    if (index == -1) {
      // Make sure all required fields are included
      final Map<String, dynamic> diagnosisToSave = {
        'id': diagnosisId,
        'name': diagnosis['name'],
        'description': diagnosis['description'],
        'accuracy': diagnosis['accuracy'],
        'imagePath': diagnosis['imagePath'], // Make sure this is included
      };
      
      _savedDiagnoses.add(diagnosisToSave);
    } else {
      // Update the diagnosis if already saved
      _savedDiagnoses[index] = {
        'id': diagnosisId,
        'name': diagnosis['name'],
        'description': diagnosis['description'],
        'accuracy': diagnosis['accuracy'],
        'imagePath': diagnosis['imagePath'], // Make sure this is included
      };
    }
    notifyListeners();
  }

  // Remove diagnosis from the saved list
  void removeDiagnosis(String diagnosisId) {
    _savedDiagnoses.removeWhere((item) => item['id'] == diagnosisId);
    notifyListeners();
  }
}