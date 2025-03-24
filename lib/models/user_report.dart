import 'dart:convert';
import 'package:capstone_dr_rice/models/disease.dart';

class UserReport {
  final Disease disease;
  final String imagePath;

  UserReport({
    required this.disease,
    required this.imagePath,
  });

  // Convert to Map for SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'disease': disease.toJson(), // Use Disease's toJson method
      'imagePath': imagePath,
    };
  }

  // Convert from Map back to UserReport
  factory UserReport.fromJson(Map<String, dynamic> json) {
    return UserReport(
      disease: Disease.fromJson(json['disease']), // Use Disease's fromJson method
      imagePath: json['imagePath'],
    );
  }

  // Convert list of reports to JSON String
  static String encode(List<UserReport> reports) =>
      json.encode(reports.map((report) => report.toJson()).toList());

  // Convert JSON String back to list of reports
  static List<UserReport> decode(String reports) =>
      (json.decode(reports) as List<dynamic>)
          .map((item) => UserReport.fromJson(item))
          .toList();
}
