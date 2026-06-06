class QueueModel {
  final String id;
  final String queueNumber;
  final String patientName;
  final String? nik;
  final String? phone;
  final String serviceName;
  final String serviceCode;
  final String patientType;
  final String? complaint;
  String status;
  final DateTime createdAt;
  final String? createdBy;

  QueueModel({
    required this.id,
    required this.queueNumber,
    required this.patientName,
    this.nik,
    this.phone,
    required this.serviceName,
    required this.serviceCode,
    required this.patientType,
    this.complaint,
    required this.status,
    required this.createdAt,
    this.createdBy,
  });

  factory QueueModel.fromJson(Map<String, dynamic> json) {
    return QueueModel(
      id: json['id'] as String,
      queueNumber: json['queueNumber'] as String,
      patientName: json['patientName'] as String,
      nik: json['nik'] as String?,
      phone: json['phone'] as String?,
      serviceName: json['serviceName'] as String,
      serviceCode: json['serviceCode'] as String,
      patientType: json['patientType'] as String,
      complaint: json['complaint'] as String?,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'queueNumber': queueNumber,
      'patientName': patientName,
      'nik': nik,
      'phone': phone,
      'serviceName': serviceName,
      'serviceCode': serviceCode,
      'patientType': patientType,
      'complaint': complaint,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'createdBy': createdBy,
    };
  }

  QueueModel copyWith({
    String? id,
    String? queueNumber,
    String? patientName,
    String? nik,
    String? phone,
    String? serviceName,
    String? serviceCode,
    String? patientType,
    String? complaint,
    String? status,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return QueueModel(
      id: id ?? this.id,
      queueNumber: queueNumber ?? this.queueNumber,
      patientName: patientName ?? this.patientName,
      nik: nik ?? this.nik,
      phone: phone ?? this.phone,
      serviceName: serviceName ?? this.serviceName,
      serviceCode: serviceCode ?? this.serviceCode,
      patientType: patientType ?? this.patientType,
      complaint: complaint ?? this.complaint,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}

class QueueStatus {
  static const String waiting = 'Menunggu';
  static const String called = 'Dipanggil';
  static const String serving = 'Dilayani';
  static const String done = 'Selesai';
  static const String cancelled = 'Dibatalkan';

  static List<String> get all => [waiting, called, serving, done, cancelled];
}
