import '../models/diagnosis_model.dart';

class DiagnosisService {
  // In a real app, this would connect to an API or local database
  // For now, we'll use the dummy data
  List<DiagnosisModel> recentDiagnoses = [];

  // Get recent diagnoses
  Future<List<DiagnosisModel>> getRecentDiagnoses() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    return recentDiagnoses;
  }

  // Toggle save diagnosis
  Future<void> toggleSaveDiagnosis(DiagnosisModel diagnosis) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Find the diagnosis in the list and toggle its saved status
    final index = recentDiagnoses.indexWhere((d) => d.id == diagnosis.id);
    if (index != -1) {
      final updatedDiagnosis = DiagnosisModel(
        id: diagnosis.id,
        userId: diagnosis.userId,
        disease: diagnosis.disease,
        scanDate: diagnosis.scanDate,
        imageUrl: diagnosis.imageUrl,
        isSaved: !diagnosis.isSaved,
      );
      
      // In a real app, you would update the database
      // For now, we'll just update the dummy data
      recentDiagnoses[index] = updatedDiagnosis;
    }
  }

  // Delete diagnosis
  Future<void> deleteDiagnosis(String id) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Remove the diagnosis from the list
    recentDiagnoses.removeWhere((d) => d.id == id);
  }
}