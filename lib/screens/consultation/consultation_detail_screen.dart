import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_helper.dart';
import '../../models/consultation_model.dart';

class ConsultationDetailScreen extends StatefulWidget {
  final ConsultationModel consultation;
  const ConsultationDetailScreen({super.key, required this.consultation});

  @override
  State<ConsultationDetailScreen> createState() => _ConsultationDetailScreenState();
}

class _ConsultationDetailScreenState extends State<ConsultationDetailScreen> {
  late ConsultationModel _c;

  @override
  void initState() {
    super.initState();
    _c = widget.consultation;
  }

  Color _statusColor(String s) {
    switch (s) {
      case ConsultationStatus.waiting: return Colors.orange;
      case ConsultationStatus.answered: return Colors.blue;
      case ConsultationStatus.done: return const Color(0xFF2E7D32);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final sc = _statusColor(_c.status);
    return Scaffold(
      appBar: AppBar(title: Text(_c.consultationCode)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Status Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: sc.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: sc.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(width: 48, height: 48,
                      decoration: BoxDecoration(color: sc.withOpacity(0.15), shape: BoxShape.circle),
                      child: Icon(Icons.chat_bubble_outline, color: sc, size: 24)),
                    const SizedBox(width: 12),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_c.consultationCode, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700, color: const Color(0xFF6A1B9A))),
                      Text(DateHelper.formatDateTime(_c.createdAt), style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                    ])),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: sc.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text(_c.status, style: GoogleFonts.poppins(fontSize: 12, color: sc, fontWeight: FontWeight.w700))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              _card('Data Pasien', [
                _row('Nama', _c.patientName),
                _row('Umur', '${_c.age} tahun'),
                _row('Jenis Kelamin', _c.gender),
                if (_c.phone != null) _row('Nomor HP', _c.phone!),
                _row('Layanan Tujuan', _c.targetService),
              ]),
              const SizedBox(height: 14),
              _card('Informasi Keluhan', [
                _row('Keluhan Utama', _c.mainComplaint),
                _row('Lama Keluhan', _c.complaintDuration),
                if (_c.symptoms.isNotEmpty)
                  _row('Gejala Tambahan', _c.symptoms.join(', ')),
                if (_c.medicalHistory != null && _c.medicalHistory!.isNotEmpty)
                  _row('Riwayat Penyakit', _c.medicalHistory!),
                if (_c.additionalNote != null && _c.additionalNote!.isNotEmpty)
                  _row('Catatan Tambahan', _c.additionalNote!),
              ]),
              // Answer from doctor
              if (_c.medicalAnswer != null && _c.medicalAnswer!.isNotEmpty) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Icon(Icons.medical_services, color: Colors.blue[700], size: 18),
                        const SizedBox(width: 8),
                        Text('Jawaban Tenaga Medis', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.blue[700])),
                      ]),
                      const SizedBox(height: 10),
                      Text(_c.medicalAnswer!, style: GoogleFonts.poppins(fontSize: 13, color: Colors.blue[900], height: 1.5)),
                      if (_c.recommendation != null) ...[
                        const SizedBox(height: 10),
                        Container(padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Icon(Icons.recommend, size: 16, color: Colors.blue[600]),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Rekomendasi: ${_c.recommendation}',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w600))),
                          ])),
                      ],
                      if (_c.answeredBy != null) ...[
                        const SizedBox(height: 8),
                        Text('Dijawab oleh: ${_c.answeredBy}',
                            style: GoogleFonts.poppins(fontSize: 11, color: Colors.blue[600], fontStyle: FontStyle.italic)),
                        if (_c.answeredAt != null)
                          Text(DateHelper.formatDateTime(_c.answeredAt!),
                              style: GoogleFonts.poppins(fontSize: 11, color: Colors.blue[400])),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 14),
              // Emergency
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 18),
                  const SizedBox(width: 8),
                  Expanded(child: Text(AppConstants.emergencyDisclaimer,
                      style: GoogleFonts.poppins(fontSize: 12, color: Colors.red[700], height: 1.5))),
                ]),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _card(String title, List<Widget> children) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
      const SizedBox(height: 12),
      ...children,
    ]),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 130, child: Text(label, style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]))),
      const Text(': ', style: TextStyle(color: Colors.grey)),
      Expanded(child: Text(value, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500))),
    ]),
  );
}
