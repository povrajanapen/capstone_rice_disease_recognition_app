// // lib/services/saved_diagnosis_service.dart
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class SavedDiagnosisService {
//   final String baseUrl = "https://api.example.com/diagnoses"; // Your API endpoint

//   Future<List<Map<String, dynamic>>> getSavedDiagnoses() async {
//     final response = await http.get(Uri.parse(baseUrl));
//     if (response.statusCode == 200) {
//       List<dynamic> data = json.decode(response.body);
//       return data.map((item) => item as Map<String, dynamic>).toList();
//     } else {
//       throw Exception('Failed to load diagnoses');
//     }
//   }

//   Future<void> saveDiagnosis(Map<String, dynamic> diagnosis) async {
//     final response = await http.post(
//       Uri.parse(baseUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode(diagnosis),
//     );
//     if (response.statusCode != 201) {
//       throw Exception('Failed to save diagnosis');
//     }
//   }

//   Future<void> removeDiagnosis(String id) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl/$id'),
//     );
//     if (response.statusCode != 200) {
//       throw Exception('Failed to delete diagnosis');
//     }
//   }
// }
