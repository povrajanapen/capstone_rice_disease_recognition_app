import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone_dr_rice/models/disease.dart';
import '../repository/disease/disease_repository.dart';

class DiseaseProvider with ChangeNotifier {
  final DiseaseRepository _diseaseRepository;
  
  // Disease catalog from repository
  List<Disease> _diseases = [];
  
  // User's saved diagnoses
  List<Map<String, dynamic>> _savedDiagnoses = [];
  
  bool _isLoading = false;

  DiseaseProvider(this._diseaseRepository) {
    _loadSavedDiagnoses();
  }

  // Getters
  List<Disease> get diseases => _diseases;
  List<Map<String, dynamic>> get savedDiagnoses => List.unmodifiable(_savedDiagnoses);
  bool get isLoading => _isLoading;

  // ===== DISEASE CATALOG METHODS =====
  
  // Fetch all diseases from repository
  Future<void> fetchDiseases() async {
    _isLoading = true;
    notifyListeners();

    try {
      _diseases = await _diseaseRepository.fetchDiseases();
    } catch (error) {
      debugPrint('Error fetching diseases: $error');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a disease to the repository
  Future<void> addDisease(Disease disease) async {
    try {
      await _diseaseRepository.addDisease(disease);
      _diseases.add(disease);  
      notifyListeners();
    } catch (error) {
      debugPrint('Error adding disease: $error');
    }
  }
  
  // Get disease details by class index
  Disease? getDiseaseByClassIndex(int classIndex) {
    try {
      return _diseases.firstWhere((d) => d.id == classIndex.toString());
    } catch (e) {
      debugPrint('Disease not found for class index: $classIndex');
      return null;
    }
  }

  // ===== SAVED DIAGNOSES METHODS =====
  
  // Check if a diagnosis is saved
  bool isDiagnosisSaved(String diagnosisId) {
    return _savedDiagnoses.any((item) => item['id'] == diagnosisId);
  }

  // Save a diagnosis with complete result screen data
  void saveDiagnosis(String id, Map<String, dynamic> diagnosis) {
    // Create a complete diagnosis record with all necessary fields
    final Map<String, dynamic> completeData = {
      'id': id,
      'name': diagnosis['name'] ?? 'Unknown Disease',
      'description': diagnosis['description'] ?? 'No description available',
      'accuracy': diagnosis['accuracy'] ?? 0.0,
      'class': diagnosis['class'], // Store the class index for the AI model
      'imagePath': diagnosis['imagePath'],
      'timestamp': diagnosis['timestamp'] ?? DateTime.now().toIso8601String(),
      // Add any other fields you want to save from the result screen
      'type': diagnosis['type'],
      'affectedPart': diagnosis['affectedPart'],
    };
    
    final index = _savedDiagnoses.indexWhere((d) => d['id'] == id);
    
    if (index != -1) {
      _savedDiagnoses[index] = completeData; // Update existing diagnosis
    } else {
      _savedDiagnoses.add(completeData);
    }
    
    _persistSavedDiagnoses(); 
    notifyListeners(); // No need to reload after persisting
  }

  // Remove a saved diagnosis
  void removeDiagnosis(String id) {
    _savedDiagnoses.removeWhere((d) => d['id'] == id);
    _persistSavedDiagnoses(); 
    notifyListeners(); // No need to reload after persisting
  }

  // Get recent diagnoses (for home screen)
  List<Map<String, dynamic>> getRecentDiagnoses({int limit = 3}) {
    // Sort by timestamp (newest first) and return limited number
    final sortedList = List<Map<String, dynamic>>.from(_savedDiagnoses);
    sortedList.sort((a, b) {
      final aTime = a['timestamp'] ?? '';
      final bTime = b['timestamp'] ?? '';
      return bTime.compareTo(aTime); // Descending order (newest first)
    });
    
    return sortedList.take(limit).toList();
  }

  // Get a saved diagnosis by ID
  Map<String, dynamic>? getSavedDiagnosisById(String diagnosisId) {
    try {
      return _savedDiagnoses.firstWhere((item) => item['id'] == diagnosisId);
    } catch (e) {
      debugPrint('Diagnosis not found: $e');
      return null;
    }
  }

  // Save diagnoses to SharedPreferences
  Future<void> _persistSavedDiagnoses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_diagnoses', jsonEncode(_savedDiagnoses));
      debugPrint('Diagnoses saved to SharedPreferences');
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
        _savedDiagnoses = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading diagnoses from SharedPreferences: $e');
    }
  }

  // Clear all saved diagnoses
  Future<void> clearAllSavedDiagnoses() async {
    _savedDiagnoses = [];
    await _persistSavedDiagnoses();
    notifyListeners();
  }
  
  // Create a complete diagnosis from scan results and disease catalog
  Map<String, dynamic> createCompleteDiagnosis(Map<String, dynamic> scanResult, String imagePath) {
    final int classIndex = (scanResult['class'] as int?) ?? -1;
    final double confidence = (scanResult['confidence'] as double?) ?? 0.0;
    
    // Try to get disease details from catalog
    Disease? diseaseInfo;
    try {
      diseaseInfo = getDiseaseByClassIndex(classIndex);
    } catch (e) {
      debugPrint('Error getting disease info: $e');
    }
    
    // Create complete diagnosis data
    return {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'class': classIndex,
      'name': diseaseInfo?.name ?? 'Unknown Disease',
      'description': diseaseInfo?.description ?? 'No description available',
      'accuracy': confidence,
      'imagePath': imagePath,
      'timestamp': DateTime.now().toIso8601String(),
      'type': diseaseInfo?.type?.toString(),
      'affectedPart': diseaseInfo?.affectedPart?.toString(),
    };
  }
}