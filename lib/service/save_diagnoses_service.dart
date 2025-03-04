import '../dummy_data/dummy_data.dart';
import '../models/diagnosis_model.dart';

List<DiagnosisModel> getSavedDiagnoses() {
  return savedDiagnoses
      .map((item) => item['diagnosis'] as DiagnosisModel)
      .toList();
}