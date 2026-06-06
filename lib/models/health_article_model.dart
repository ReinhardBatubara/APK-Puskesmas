class HealthArticleModel {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String readTime;
  final DateTime publishedDate;

  const HealthArticleModel({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.readTime,
    required this.publishedDate,
  });

  factory HealthArticleModel.fromJson(Map<String, dynamic> json) {
    return HealthArticleModel(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      readTime: json['readTime'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'summary': summary,
      'content': content,
      'category': category,
      'readTime': readTime,
      'publishedDate': publishedDate.toIso8601String(),
    };
  }

  HealthArticleModel copyWith({
    String? id,
    String? title,
    String? summary,
    String? content,
    String? category,
    String? readTime,
    DateTime? publishedDate,
  }) {
    return HealthArticleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      content: content ?? this.content,
      category: category ?? this.category,
      readTime: readTime ?? this.readTime,
      publishedDate: publishedDate ?? this.publishedDate,
    );
  }
}
