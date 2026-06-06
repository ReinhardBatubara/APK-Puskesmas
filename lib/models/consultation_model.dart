class ConsultationModel {
  final String id;
  final String consultationCode;
  final String patientName;
  final int age;
  final String gender;
  final String? phone;
  final String targetService;
  final String mainComplaint;
  final String complaintDuration;
  final List<String> symptoms;
  final String? medicalHistory;
  final String? additionalNote;
  String status;
  final DateTime createdAt;
  final String? createdBy;
  String? medicalAnswer;
  String? recommendation;
  String? answeredBy;
  DateTime? answeredAt;
  String? doctorNote;

  ConsultationModel({
    required this.id,
    required this.consultationCode,
    required this.patientName,
    required this.age,
    required this.gender,
    this.phone,
    required this.targetService,
    required this.mainComplaint,
    required this.complaintDuration,
    required this.symptoms,
    this.medicalHistory,
    this.additionalNote,
    required this.status,
    required this.createdAt,
    this.createdBy,
    this.medicalAnswer,
    this.recommendation,
    this.answeredBy,
    this.answeredAt,
    this.doctorNote,
  });

  factory ConsultationModel.fromJson(Map<String, dynamic> json) {
    return ConsultationModel(
      id: json['id'] as String,
      consultationCode: json['consultationCode'] as String,
      patientName: json['patientName'] as String,
      age: json['age'] as int,
      gender: json['gender'] as String,
      phone: json['phone'] as String?,
      targetService: json['targetService'] as String,
      mainComplaint: json['mainComplaint'] as String,
      complaintDuration: json['complaintDuration'] as String,
      symptoms: List<String>.from(json['symptoms'] as List),
      medicalHistory: json['medicalHistory'] as String?,
      additionalNote: json['additionalNote'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      medicalAnswer: json['medicalAnswer'] as String?,
      recommendation: json['recommendation'] as String?,
      answeredBy: json['answeredBy'] as String?,
      answeredAt: json['answeredAt'] != null
          ? DateTime.parse(json['answeredAt'] as String)
          : null,
      doctorNote: json['doctorNote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultationCode': consultationCode,
      'patientName': patientName,
      'age': age,
      'gender': gender,
      'phone': phone,
      'targetService': targetService,
      'mainComplaint': mainComplaint,
      'complaintDuration': complaintDuration,
      'symptoms': symptoms,
      'medicalHistory': medicalHistory,
      'additionalNote': additionalNote,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
      'medicalAnswer': medicalAnswer,
      'recommendation': recommendation,
      'answeredBy': answeredBy,
      'answeredAt': answeredAt?.toIso8601String(),
      'doctorNote': doctorNote,
    };
  }

  ConsultationModel copyWith({
    String? id,
    String? consultationCode,
    String? patientName,
    int? age,
    String? gender,
    String? phone,
    String? targetService,
    String? mainComplaint,
    String? complaintDuration,
    List<String>? symptoms,
    String? medicalHistory,
    String? additionalNote,
    String? status,
    DateTime? createdAt,
    String? createdBy,
    String? medicalAnswer,
    String? recommendation,
    String? answeredBy,
    DateTime? answeredAt,
    String? doctorNote,
  }) {
    return ConsultationModel(
      id: id ?? this.id,
      consultationCode: consultationCode ?? this.consultationCode,
      patientName: patientName ?? this.patientName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      targetService: targetService ?? this.targetService,
      mainComplaint: mainComplaint ?? this.mainComplaint,
      complaintDuration: complaintDuration ?? this.complaintDuration,
      symptoms: symptoms ?? this.symptoms,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      additionalNote: additionalNote ?? this.additionalNote,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      medicalAnswer: medicalAnswer ?? this.medicalAnswer,
      recommendation: recommendation ?? this.recommendation,
      answeredBy: answeredBy ?? this.answeredBy,
      answeredAt: answeredAt ?? this.answeredAt,
      doctorNote: doctorNote ?? this.doctorNote,
    );
  }
}

class ConsultationStatus {
  static const String waiting = 'Menunggu Jawaban';
  static const String answered = 'Dijawab';
  static const String done = 'Selesai';

  static List<String> get all => [waiting, answered, done];
}
