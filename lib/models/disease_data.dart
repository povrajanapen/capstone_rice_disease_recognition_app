// disease_data.dart
import 'dart:convert';
import 'package:capstone_dr_rice/models/disease.dart';
import 'package:flutter/services.dart' show rootBundle;

class DiseaseDataLoader {
  static Future<List<Disease>> loadDiseases() async {
    final String jsonString = await rootBundle.loadString(
      'assets/data/disease_data.json',
    );
    final Map<String, dynamic> jsonData = jsonDecode(jsonString);
    final List<dynamic> diseasesJson = jsonData['diseases'];
    return diseasesJson.map((json) => Disease.fromJson(json)).toList();
  }

  static Future<Map<String, Disease>> loadDiseaseMap() async {
    final List<Disease> diseases = await loadDiseases();
    return {for (var disease in diseases) disease.name: disease};
  }
}
