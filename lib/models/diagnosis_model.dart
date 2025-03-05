//diagnosis model
import 'package:capstone_dr_rice/models/disease.dart';

class DiagnosisModel {
  final String id;
  final String userId;
  final Disease disease;
  final DateTime scanDate;
  final String? imageUrl; // Scanned image URL
  final bool isSaved;

  DiagnosisModel({
    required this.id,
    required this.userId,
    required this.disease,
    required this.scanDate,
    required this.imageUrl,
    required this.isSaved,
  });

  // Convert JSON to Diagnosis object
  factory DiagnosisModel.fromJson(Map<String, dynamic> json) {
    return DiagnosisModel(
      id: json['id'],
      userId: json['userId'],
      disease: Disease.fromJson(json['disease']),
      scanDate: DateTime.parse(json['scanDate']),
      imageUrl: json['imageUrl'],
      isSaved: json['isSaved'],
    );
  }

  // Convert Diagnosis object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'disease': disease.toJson(),
      'scanDate': scanDate.toIso8601String(),
      'imageUrl': imageUrl,
      'isSaved': isSaved,
    };
  }

  bool get isNetworkImage {
    return imageUrl != null && imageUrl!.startsWith('http');
  }

  // Fallback if API image is missing
  String get validImageUrl {
    return imageUrl?.isNotEmpty == true ? imageUrl! : 'assets/images/placeholder.png';
  }

}
