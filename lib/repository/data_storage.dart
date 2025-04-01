import 'dart:convert';
import 'dart:io';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:path_provider/path_provider.dart';

class DiagnosesStorage {
  static Future<String> get _diagnosesFilePath async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/diagnoses.json';
  }

  static Future<String> _saveImage(
    String sourcePath,
    String diagnosisId,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${directory.path}/diagnosis_images');
    if (!await imageDir.exists()) {
      await imageDir.create();
    }
    final newPath = '${imageDir.path}/$diagnosisId.jpg';
    await File(sourcePath).copy(newPath);
    print('Image saved to: $newPath');
    return newPath;
  }

  static Future<List<Diagnose>> loadDiagnoses() async {
    try {
      final filePath = await _diagnosesFilePath;
      final file = File(filePath);
      if (!await file.exists()) {
        print('No diagnoses file found at $filePath');
        return [];
      }
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      final diagnoses =
          jsonData.map((json) => Diagnose.fromJson(json)).toList();
      print('Loaded ${diagnoses.length} diagnoses from $filePath');
      return diagnoses;
    } catch (e) {
      print('Error loading diagnoses: $e');
      return [];
    }
  }

  static Future<void> saveDiagnoses(List<Diagnose> diagnoses) async {
    try {
      final filePath = await _diagnosesFilePath;
      final file = File(filePath);
      final jsonString = jsonEncode(diagnoses.map((d) => d.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving diagnoses: $e');
    }
  }

  static Future<void> addDiagnosis(
    Diagnose diagnosis,
    String sourceImagePath,
  ) async {
    final diagnoses = await loadDiagnoses();
    final newImagePath = await _saveImage(sourceImagePath, diagnosis.id);
    final updatedDiagnosis = Diagnose(
      id: diagnosis.id,
      disease: diagnosis.disease,
      timestamp: diagnosis.timestamp,
      imagePath: newImagePath,
      confidence: diagnosis.confidence,
      userId: diagnosis.userId,
      isSaved: diagnosis.isSaved, // Preserve isSaved from input
    );
    diagnoses.removeWhere(
      (d) => d.id == updatedDiagnosis.id,
    ); // Avoid duplicates by ID
    diagnoses.add(updatedDiagnosis);
    await saveDiagnoses(diagnoses); // Persist the updated list
    print('Added diagnosis ${diagnosis.id}, total: ${diagnoses.length}');
  }
}
