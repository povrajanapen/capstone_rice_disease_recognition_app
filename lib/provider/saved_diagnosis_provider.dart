import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DiagnosisProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _savedDiagnoses = [];

  // Constructor - load saved diagnoses when provider is initialized
  DiagnosisProvider() {
    _loadSavedDiagnoses();
  }

  // Getter to fetch saved diagnoses
  List<Map<String, dynamic>> get savedDiagnoses => List.unmodifiable(_savedDiagnoses);

  // Check if a diagnosis is already saved
  bool isDiagnosisSaved(String diagnosisId) {
    return _savedDiagnoses.any((item) => item['id'] == diagnosisId);
  }

  // Add or update diagnosis in the saved list
  Future<void> saveDiagnosis(String diagnosisId, Map<String, dynamic> diagnosis) async {
    try {
      final index = _savedDiagnoses.indexWhere((item) => item['id'] == diagnosisId);

      final Map<String, dynamic> diagnosisToSave = {
        'id': diagnosisId,
        'name': diagnosis['name'] ?? 'Unknown Disease',
        'description': diagnosis['description'] ?? 'No description available',
        'accuracy': diagnosis['accuracy'] ?? 0.0,
        'imagePath': diagnosis['imagePath'] ?? '',
        'timestamp': diagnosis['timestamp'] ?? DateTime.now().toIso8601String(),
      };

      if (index == -1) {
        _savedDiagnoses.add(diagnosisToSave);
      } else {
        _savedDiagnoses[index] = diagnosisToSave;
      }

      await _persistSavedDiagnoses();
      notifyListeners();
    } catch (e) {
      debugPrint('Error saving diagnosis: $e');
    }
  }

  // Remove a specific diagnosis
  Future<void> removeDiagnosis(String diagnosisId) async {
    _savedDiagnoses.removeWhere((item) => item['id'] == diagnosisId);
    await _persistSavedDiagnoses();
    notifyListeners();
  }

  // Get recent diagnoses (sorted by newest)
  List<Map<String, dynamic>> getRecentDiagnoses({int limit = 3}) {
    final sortedList = List<Map<String, dynamic>>.from(_savedDiagnoses);
    sortedList.sort((a, b) => (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));
    return sortedList.take(limit).toList();
  }

  // Persist diagnoses to SharedPreferences
  Future<void> _persistSavedDiagnoses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(_savedDiagnoses);
      await prefs.setString('saved_diagnoses', jsonString);
    } catch (e) {
      debugPrint('Error saving diagnoses to SharedPreferences: $e');
    }
  }

  // Load diagnoses from SharedPreferences
  Future<void> _loadSavedDiagnoses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('saved_diagnoses');

      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonString);
        _savedDiagnoses.clear();
        _savedDiagnoses.addAll(decoded.map((e) => Map<String, dynamic>.from(e)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading diagnoses from SharedPreferences: $e');
    }
  }

  // Clear all saved diagnoses
  Future<void> clearAllSavedDiagnoses() async {
    _savedDiagnoses.clear();
    await _persistSavedDiagnoses();
    notifyListeners();
  }
}
