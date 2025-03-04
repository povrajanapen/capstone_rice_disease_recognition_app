enum DiseaseType {
  bacterial,
  fungal,
  parasitic,
}

class Disease {
  final String id;
  final String name;
  final String description;
  final DiseaseType type;
  final DateTime scanDate;
  final double accuracy;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.scanDate,
    required this.accuracy,
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