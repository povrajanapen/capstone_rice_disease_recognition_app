// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class DiagnosisProvider extends ChangeNotifier {
//   List<Map<String, dynamic>> _savedDiagnoses = [];

//   DiagnosisProvider() {
//     _loadSavedDiagnoses();
//   }
//   List<Map<String, dynamic>> get savedDiagnoses => List.unmodifiable(_savedDiagnoses);

//   bool isDiagnosisSaved(String diagnosisId) {
//     return _savedDiagnoses.any((item) => item['id'] == diagnosisId);
//   }

//   void saveDiagnosis(String id, Map<String, dynamic> diagnosis) {
//     final index = _savedDiagnoses.indexWhere((d) => d['id'] == id);
//     if (index != -1) {
//       _savedDiagnoses[index] = {'id': id, ...diagnosis}; // Update existing diagnosis
//     } else {
//       _savedDiagnoses.add({'id': id, ...diagnosis});
//     }
    
//     debugPrint('Saved Diagnoses: $_savedDiagnoses');
//     _persistSavedDiagnoses(); 
//     _loadSavedDiagnoses();  
//     notifyListeners();
//     debugPrint('notifyListeners called');
//   }

//   void removeDiagnosis(String id) {
//     _savedDiagnoses.removeWhere((d) => d['id'] == id);
//     _persistSavedDiagnoses(); 
//     _loadSavedDiagnoses();  
//     notifyListeners();
//     debugPrint('notifyListeners called');
//   }

//   Future<void> _persistSavedDiagnoses() async {
//   try {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('saved_diagnoses', jsonEncode(_savedDiagnoses));
//     debugPrint('Diagnoses saved to SharedPreferences');
//   } catch (e) {
//     debugPrint('Error saving diagnoses to SharedPreferences: $e');
//   }
// }


//   Future<void> _loadSavedDiagnoses() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final jsonString = prefs.getString('saved_diagnoses');
      
//       if (jsonString != null && jsonString.isNotEmpty) {
//         final List<dynamic> decoded = jsonDecode(jsonString);
//         _savedDiagnoses = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
//         notifyListeners();
//       }
//     } catch (e) {
//       debugPrint('Error loading diagnoses from SharedPreferences: $e');
//     }
//   }

//   Future<void> clearAllSavedDiagnoses() async {
//     _savedDiagnoses = [];
//     await _persistSavedDiagnoses();
//     notifyListeners();
//   }
// }
