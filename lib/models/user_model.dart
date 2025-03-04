// user model
class UserModel {
    final String id;
  final String name;
  final String phoneNumber;
  final List<String> savedDiagnosisIds; // Stores IDs of saved diagnoses

  UserModel({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.savedDiagnosisIds,
  });

  // Convert JSON to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      savedDiagnosisIds: List<String>.from(json['savedDiagnosisIds']),
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'savedDiagnosisIds': savedDiagnosisIds,
    };
  }

}
