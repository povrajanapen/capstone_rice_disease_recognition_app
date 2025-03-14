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

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.scanDate,
    required this.accuracy,
    this.affectedPart,
  });

  // Convert JSON to Disease object
  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: DiseaseType.values.firstWhere((e) => e.name == json['type']),
      scanDate: DateTime.parse(json['scanDate']),
      accuracy: json['accuracy'].toDouble(), 
      affectedPart: DiseasePart.values.firstWhere((e) => e.name == json['affectedPart']),

    );
  }

  // Convert Disease object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.name, // Convert enum to string
      'scanDate': scanDate.toIso8601String(),
      'accuracy': accuracy,
    };
  }

}