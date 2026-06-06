class DoctorModel {
  final String id;
  final String name;
  final String specialty;
  final String schedule;
  final String? note;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.schedule,
    this.note,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      schedule: json['schedule'] as String,
      note: json['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'schedule': schedule,
      'note': note,
    };
  }
}
