import 'dart:io';
enum DiseaseType {
  bacterial,
  fungal,
  parasitic,
}

enum DiseasePart {
  leaf,
  stem,
  root,
  panicle,
  grain
}




class Disease {
  final String id;
  final String name;
  final String description;
  final DiseaseType type;
  final DiseasePart? affectedPart;
  final DateTime scanDate;
  final double accuracy;
  final String? imagePath; 

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.scanDate,
    required this.accuracy,
    this.affectedPart,
    this.imagePath,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: DiseaseType.values.firstWhere((e) => e.name == json['type']),
      scanDate: DateTime.parse(json['scanDate']),
      accuracy: (json['accuracy'] as num).toDouble(),
      affectedPart: json['affectedPart'] != null
          ? DiseasePart.values.firstWhere((e) => e.name == json['affectedPart'])
          : null,
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'scanDate': scanDate.toIso8601String(),
      'accuracy': accuracy,
      'affectedPart': affectedPart?.name,
      'imagePath': imagePath,
    };
  }

  int get accuracyPercentage => (accuracy * 100).toInt();

  String get formattedDate {
    return "${scanDate.day}/${scanDate.month}/${scanDate.year}";
  }
}
