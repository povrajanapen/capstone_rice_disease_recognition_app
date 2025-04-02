import 'dart:io';
import 'package:capstone_dr_rice/repository/data_storage.dart';
import 'package:flutter/material.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:path_provider/path_provider.dart';

class DiagnosisProvider with ChangeNotifier {
  List<Diagnose> _savedDiagnoses = [];
  List<Diagnose> _recentDiagnoses = [];

  List<Diagnose> get savedDiagnoses => _savedDiagnoses;
  List<Diagnose> get recentDiagnoses => _recentDiagnoses;

  DiagnosisProvider() {
    _loadSavedDiagnoses();
  }

  Future<void> _loadSavedDiagnoses() async {
    _savedDiagnoses = await DiagnosesStorage.loadDiagnoses();
    _savedDiagnoses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/diagnosis_images');
    if (!await imageDir.exists()) {
      await imageDir.create();
    }
    for (var diagnose in _savedDiagnoses) {
      final expectedPath = '${imageDir.path}/${diagnose.id}.jpg';
      if (diagnose.imagePath != expectedPath &&
          await File(diagnose.imagePath).exists()) {
        await File(diagnose.imagePath).copy(expectedPath);
        diagnose = Diagnose(
          id: diagnose.id,
          disease: diagnose.disease,
          timestamp: diagnose.timestamp,
          imagePath: expectedPath,
          confidence: diagnose.confidence,
          userId: diagnose.userId,
          isSaved: diagnose.isSaved,
        );
      }
      
    }
    _recentDiagnoses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    notifyListeners();
  }

  Future<void> addDiagnosis(
    Diagnose diagnose,
    String imagePath, {
    bool save = false,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final imageDir = Directory('${appDir.path}/diagnosis_images');
    if (!await imageDir.exists()) {
      await imageDir.create();
    }
    final newImagePath = '${imageDir.path}/${diagnose.id}.jpg';
    if (await File(imagePath).exists()) {
      await File(imagePath).copy(newImagePath);
      print('Image copied to: $newImagePath');
    } else {
      print('Warning: Original image at $imagePath not found');
    }

    final updatedDiagnose = Diagnose(
      id: diagnose.id,
      disease: diagnose.disease,
      timestamp: diagnose.timestamp,
      imagePath: newImagePath,
      confidence: diagnose.confidence,
      userId: diagnose.userId,
      isSaved: save,
    );

    if (save) {
      // Save to persistent storage and update saved list
      await DiagnosesStorage.addDiagnosis(updatedDiagnose, newImagePath);
      _savedDiagnoses = await DiagnosesStorage.loadDiagnoses();
      _savedDiagnoses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    } else {

      final existingIndex = _recentDiagnoses.indexWhere(
        (d) => d.id == updatedDiagnose.id,
      );
      if (existingIndex != -1) {
        _recentDiagnoses[existingIndex] = updatedDiagnose;
      } else {
        _recentDiagnoses.add(updatedDiagnose);
      }
      _recentDiagnoses.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    }
    notifyListeners();
  }

  Future<void> removeDiagnosis(String? id) async {
    if (id == null) return;
    _recentDiagnoses.removeWhere((d) => d.id == id);
    _savedDiagnoses.removeWhere((d) => d.id == id);
    final diagnoses = await DiagnosesStorage.loadDiagnoses();
    diagnoses.removeWhere((d) => d.id == id);
    await DiagnosesStorage.saveDiagnoses(diagnoses);
    _savedDiagnoses = diagnoses;
    notifyListeners();
  }

  List<Diagnose> getRecentDiagnoses({int limit = 3}) {
    return _recentDiagnoses.take(limit).toList();
  }
}
