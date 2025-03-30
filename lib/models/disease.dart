
enum DiseasePart {
  leaves,
  sheath,
  grains,
  stem,
  wholePlant;

  String get name {
    switch (this) {
      case DiseasePart.leaves:
        return 'Leaves';
      case DiseasePart.sheath:
        return 'Sheath';
      case DiseasePart.grains:
        return 'Grains';
      case DiseasePart.stem:
        return 'Stem';
      case DiseasePart.wholePlant:
        return 'Whole Plant';
    }
  }

  factory DiseasePart.fromJson(String value) {
    return DiseasePart.values.firstWhere(
      (e) => e.toString().split('.')[1] == value.toLowerCase(),
      orElse: () => DiseasePart.leaves, // Default fallback
    );
  }

  String toJson() => toString().split('.')[1];
}

enum DiseaseType {
  bacterial,
  fungal,
  viral,
  pest;

  String get name {
    switch (this) {
      case DiseaseType.bacterial:
        return 'Bacterial';
      case DiseaseType.fungal:
        return 'Fungal';
      case DiseaseType.viral:
        return 'Viral';
      case DiseaseType.pest:
        return 'Pest';
    }
  }

  factory DiseaseType.fromJson(String value) {
    return DiseaseType.values.firstWhere(
      (e) => e.toString().split('.')[1] == value.toLowerCase(),
      orElse: () => DiseaseType.bacterial, // Default fallback
    );
  }

  String toJson() => toString().split('.')[1];
}
class Disease {
  final String id;
  final String name;
  final String description;
  final DiseasePart? affectedPart;
  final DiseaseType type;
  final String symptoms;
  final String management;
  final String? imageUrl;

  Disease({
    required this.id,
    required this.name,
    required this.description,
    this.affectedPart,
    required this.type,
    required this.symptoms,
    required this.management,
    this.imageUrl,
  });

  factory Disease.fromJson(Map<String, dynamic> json) {
    return Disease(
      id: json['id'] as String? ?? json['name'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? json['symptoms'] as String,
      affectedPart:
          json['affectedPart'] != null
              ? DiseasePart.fromJson(json['affectedPart'] as String)
              : null,
      type: DiseaseType.fromJson(json['type'] as String),
      symptoms: json['symptoms'] as String,
      management: json['management'] as String,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'affectedPart': affectedPart?.toJson(),
    'type': type.toJson(),
    'symptoms': symptoms,
    'management': management,
    'imageUrl': imageUrl,
  };
}

class Diagnose {
  final String id;
  final Disease disease;
  final DateTime timestamp;
  final String imagePath;
  final double confidence;
  final String? userId;

  Diagnose({
    required this.id,
    required this.disease,
    required this.timestamp,
    required this.imagePath,
    required this.confidence,
    this.userId,
  });

  factory Diagnose.fromJson(Map<String, dynamic> json) {
    return Diagnose(
      id: json['id'] as String,
      disease: Disease.fromJson(json['disease'] as Map<String, dynamic>),
      timestamp: DateTime.parse(json['timestamp'] as String),
      imagePath: json['imagePath'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      userId: json['userId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'disease': disease.toJson(),
    'timestamp': timestamp.toIso8601String(),
    'imagePath': imagePath,
    'confidence': confidence,
    'userId': userId,
  };
}

class User {
  final String id;
  final String username;
  final String? email;
  final List<Diagnose>? diagnoses;

  User({required this.id, required this.username, this.email, this.diagnoses});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      diagnoses:
          json['diagnoses'] != null
              ? (json['diagnoses'] as List)
                  .map((d) => Diagnose.fromJson(d as Map<String, dynamic>))
                  .toList()
              : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'diagnoses': diagnoses?.map((d) => d.toJson()).toList(),
  };
}
