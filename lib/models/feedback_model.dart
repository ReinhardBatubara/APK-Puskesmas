class FeedbackModel {
  final String id;
  final String name;
  final String category;
  final int rating;
  final String message;
  final DateTime createdAt;

  const FeedbackModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.message,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      rating: json['rating'] as int,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'rating': rating,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
