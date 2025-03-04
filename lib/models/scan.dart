import 'package:uuid/uuid.dart';  // To generate unique UUIDs
import 'disease.dart';

enum ScanStatus { pending, completed, failed }

class Scan {
  final String id;  // Unique ID for each scan
  final String userId;
  final String imageUrl;
  final DateTime scanDate;
  final ScanStatus status;
  final double confidenceScore;
  final Disease? predictedDisease;

  // Constructor generates a unique ID if not provided
  Scan({
    String? id,
    required this.userId,
    required this.imageUrl,
    required this.scanDate,
    required this.status,
    required this.confidenceScore,
    this.predictedDisease,
  }) : id = id ?? Uuid().v4();  // Generate UUID if no ID is provided

  // Convert JSON to Scan object
  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      id: json['id'],
      userId: json['userId'],
      imageUrl: json['imageUrl'],
      scanDate: DateTime.parse(json['scanDate']),
      status: ScanStatus.values.firstWhere((e) => e.toString() == 'ScanStatus.${json['status']}'),
      confidenceScore: json['confidenceScore'].toDouble(),
      predictedDisease: json['predictedDisease'] != null
          ? Disease.fromJson(json['predictedDisease'])
          : null,
    );
  }

  // Convert Scan object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'imageUrl': imageUrl,
      'scanDate': scanDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'confidenceScore': confidenceScore,
      'predictedDisease': predictedDisease?.toJson(),
    };
  }
}