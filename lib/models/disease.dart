import 'package:collection/collection.dart';

enum DiseaseType {
  bacterial,
  fungal,
  parasitic,
  viral,
}

enum DiseasePart {
  leaf,
  stem,
  root,
  panicle,
  grain,
}

class Disease {
  final String id;
  final String name;
  final String description;
  final DiseaseType type;
  final DiseasePart? affectedPart;
  final DateTime? scanDate;
  final double? accuracy;
  final String? imagePath;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.scanDate,
    this.accuracy,
    this.affectedPart,
    this.imagePath,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      type: DiseaseType.values.firstWhereOrNull((e) => e.name == json['type']) ?? DiseaseType.bacterial,
      scanDate: json['scanDate'] != null ? DateTime.tryParse(json['scanDate']) : null,
      accuracy: (json['accuracy'] as num?)?.toDouble() ?? 0.0,
      affectedPart: DiseasePart.values.firstWhereOrNull((e) => e.name == json['affectedPart']),
      imagePath: json['imagePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name,
      'scanDate': scanDate?.toIso8601String(),
      'accuracy': accuracy,
      'affectedPart': affectedPart?.name,
      'imagePath': imagePath,
    };
  }

  int get accuracyPercentage => ((accuracy ?? 0) * 100).toInt();

  String get formattedDate => scanDate != null
      ? "${scanDate!.day}/${scanDate!.month}/${scanDate!.year}"
      : "Unknown date";

//allows updating fields without modifying the original instance
  Disease copyWith({
    String? id,
    String? name,
    String? description,
    DiseaseType? type,
    DiseasePart? affectedPart,
    DateTime? scanDate,
    double? accuracy,
    String? imagePath,
  }) {
    return Disease(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      affectedPart: affectedPart ?? this.affectedPart,
      scanDate: scanDate ?? this.scanDate,
      accuracy: accuracy ?? this.accuracy,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() {
    return 'Disease(id: $id, name: $name, type: $type, affectedPart: $affectedPart, accuracy: $accuracy, scanDate: $scanDate, imagePath: $imagePath)';
  }
}
