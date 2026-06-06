class ServiceModel {
  final String id;
  final String name;
  final int iconCode;
  final String description;
  final String requirements;
  final String estimatedTime;
  final String note;
  final String queueCode;

  const ServiceModel({
    required this.id,
    required this.name,
    required this.iconCode,
    required this.description,
    required this.requirements,
    required this.estimatedTime,
    required this.note,
    required this.queueCode,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      iconCode: json['iconCode'] as int,
      description: json['description'] as String,
      requirements: json['requirements'] as String,
      estimatedTime: json['estimatedTime'] as String,
      note: json['note'] as String,
      queueCode: json['queueCode'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconCode': iconCode,
      'description': description,
      'requirements': requirements,
      'estimatedTime': estimatedTime,
      'note': note,
      'queueCode': queueCode,
    };
  }

  ServiceModel copyWith({
    String? id,
    String? name,
    int? iconCode,
    String? description,
    String? requirements,
    String? estimatedTime,
    String? note,
    String? queueCode,
  }) {
    return ServiceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCode: iconCode ?? this.iconCode,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      note: note ?? this.note,
      queueCode: queueCode ?? this.queueCode,
    );
  }
}
