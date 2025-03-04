class FeedbackModel {
  final String id;
  final String userId;
  final String diagnosisId;
  final int rating; // 1-5 stars
  final String comment;
  final DateTime createdAt;

  FeedbackModel({
    required this.id,
    required this.userId,
    required this.diagnosisId,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  // Convert JSON to FeedbackModel object
  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      userId: json['userId'],
      diagnosisId: json['diagnosisId'],
      rating: json['rating'],
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // Convert FeedbackModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'diagnosisId': diagnosisId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }

}