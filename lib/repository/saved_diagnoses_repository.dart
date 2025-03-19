// // lib/repositories/saved_diagnosis_repository.dart


// import '../service/save_diagnoses_service.dart';

// class SavedDiagnosisRepository {
//   final SavedDiagnosisService _service = SavedDiagnosisService();

//   Future<List<Map<String, dynamic>>> getSavedDiagnoses() async {
//     return await _service.getSavedDiagnoses();
//   }

//   Future<void> saveDiagnosis(Map<String, dynamic> diagnosis) async {
//     return await _service.saveDiagnosis(diagnosis); // Save via service
//   }

//   Future<void> removeDiagnosis(String id) async {
//     return await _service.removeDiagnosis(id); // Remove via service
//   }
// }
