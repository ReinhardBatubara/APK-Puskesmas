import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/consultation_model.dart';
import '../../core/utils/local_storage_helper.dart';

class MedicalConsultationDetailScreen extends StatefulWidget {
  final ConsultationModel consultation;
  const MedicalConsultationDetailScreen({super.key, required this.consultation});

  @override
  State<MedicalConsultationDetailScreen> createState() => _MedicalConsultationDetailScreenState();
}

class _MedicalConsultationDetailScreenState extends State<MedicalConsultationDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _answerCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  final _doctorNameCtrl = TextEditingController();
  String _selectedRecommendation = 'Datang ke puskesmas';
  bool _submitting = false;

  final List<String> _recommendations = [
    'Datang ke puskesmas',
    'Istirahat mandiri di rumah',
    'Beli obat bebas di apotek',
    'Rujuk ke Rumah Sakit tingkat lanjut'
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
  }

  Future<void> _loadDoctorName() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (session != null && session['name'] != null) {
      setState(() {
        _doctorNameCtrl.text = session['name'];
      });
    } else {
      _doctorNameCtrl.text = 'dr. Sari Simanjuntak';
    }
  }

  @override
  void dispose() {
    _answerCtrl.dispose();
    _noteCtrl.dispose();
    _doctorNameCtrl.dispose();
    super.dispose();
  }

  void _submitAnswer() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    final updated = ConsultationModel(
      id: widget.consultation.id,
      consultationCode: widget.consultation.consultationCode,
      patientName: widget.consultation.patientName,
      age: widget.consultation.age,
      gender: widget.consultation.gender,
      phone: widget.consultation.phone,
      targetService: widget.consultation.targetService,
      mainComplaint: widget.consultation.mainComplaint,
      complaintDuration: widget.consultation.complaintDuration,
      symptoms: widget.consultation.symptoms,
      medicalHistory: widget.consultation.medicalHistory,
      additionalNote: widget.consultation.additionalNote,
      status: ConsultationStatus.answered,
      createdAt: widget.consultation.createdAt,
      createdBy: widget.consultation.createdBy,
      medicalAnswer: _answerCtrl.text.trim(),
      recommendation: _selectedRecommendation,
      answeredBy: _doctorNameCtrl.text.trim(),
      answeredAt: DateTime.now(),
      doctorNote: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Jawaban konsultasi berhasil dikirim!', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: Colors.green[700],
        behavior: SnackBarBehavior.floating,
      ),
    );

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.consultation;
    final isPending = item.status == ConsultationStatus.waiting;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Konsultasi'),
        backgroundColor: const Color(0xFF1565C0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient overview Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.consultationCode,
                        style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1565C0)),
                      ),
                      Text(
                        isPending ? 'Menunggu Jawaban' : 'Terjawab',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPending ? Colors.orange[800] : Colors.green[800],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Text(
                    item.patientName,
                    style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Profil: ${item.gender}, ${item.age} tahun',
                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (item.phone != null)
                    Text(
                      'No. HP: ${item.phone}',
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                    ),
                  const SizedBox(height: 12),
                  Text(
                    'Keluhan Utama:',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  Text(
                    item.mainComplaint,
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Durasi Keluhan: ${item.complaintDuration}',
                    style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[750]),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Symptoms & History Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Gejala yang Dirasakan:',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: item.symptoms.map((s) => Chip(
                      label: Text(s, style: GoogleFonts.poppins(fontSize: 10)),
                      padding: EdgeInsets.zero,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    )).toList(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Riwayat Penyakit Dahulu:',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                  ),
                  Text(
                    item.medicalHistory ?? 'Tidak ada riwayat penyakit serius',
                    style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                  ),
                  if (item.additionalNote != null) ...[
                    const SizedBox(height: 14),
                    Text(
                      'Catatan Tambahan:',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    Text(
                      item.additionalNote!,
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Answer / Diagnosis interface
            if (isPending) ...[
              Text(
                'Tanggapan Medis Dokter',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _doctorNameCtrl,
                        decoration: const InputDecoration(labelText: 'Nama Dokter Pemeriksa'),
                        validator: (v) => (v == null || v.isEmpty) ? 'Nama dokter harus diisi' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedRecommendation,
                        items: _recommendations.map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(r, style: GoogleFonts.poppins(fontSize: 12)),
                        )).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedRecommendation = val);
                          }
                        },
                        decoration: const InputDecoration(labelText: 'Rekomendasi Tindakan'),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _answerCtrl,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Tulis diagnosis sementara, saran obat, atau anjuran medis...',
                          labelText: 'Jawaban / Diagnosis Medis',
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Jawaban medis tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _noteCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Contoh: Istirahat yang cukup, hindari air es',
                          labelText: 'Catatan Dokter (Opsional)',
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1565C0)),
                          onPressed: _submitAnswer,
                          child: const Text('Kirim Tanggapan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Already Answered Readout
              Text(
                'Tanggapan Medis Dokter',
                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user_outlined, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          item.answeredBy ?? 'Tenaga Medis',
                          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green[900]),
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Text(
                      'Rekomendasi Tindakan:',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    Text(
                      item.recommendation ?? 'Tidak ada rekomendasi khusus',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Jawaban / Diagnosis Medis:',
                      style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                    ),
                    Text(
                      item.medicalAnswer ?? '-',
                      style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                    ),
                    if (item.doctorNote != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        'Catatan Tambahan:',
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                      ),
                      Text(
                        item.doctorNote!,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
