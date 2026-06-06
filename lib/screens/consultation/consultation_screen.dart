import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/consultation_model.dart';
import '../../widgets/consultation_card.dart';
import '../../widgets/empty_state_widget.dart';
import 'consultation_form_screen.dart';
import 'consultation_detail_screen.dart';
import 'consultation_history_screen.dart';

class ConsultationScreen extends StatefulWidget {
  const ConsultationScreen({super.key});

  @override
  State<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends State<ConsultationScreen> {
  List<ConsultationModel> _recent = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final session = await LocalStorageHelper.getLoginSession();
    _userId = session?['id'];
    final raw = await LocalStorageHelper.getConsultations();
    final all = [...DummyData.dummyConsultations.map((c) => c.toJson()), ...raw];
    List<ConsultationModel> list = all.map((c) => ConsultationModel.fromJson(c)).toList();
    if (_userId != null) {
      list = list.where((c) => c.createdBy == _userId).toList();
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (!mounted) return;
    setState(() => _recent = list.take(3).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konsultasi Kesehatan')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Fitur konsultasi ini digunakan untuk konsultasi kesehatan awal. Fitur ini bukan pengganti pemeriksaan langsung oleh dokter.',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.blue[700], height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Action Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsultationFormScreen()));
                    _load();
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: Text('Buat Konsultasi Baru', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ConsultationHistoryScreen())),
                  icon: const Icon(Icons.history),
                  label: Text('Riwayat Konsultasi', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF2E7D32),
                    side: const BorderSide(color: Color(0xFF2E7D32)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Emergency Disclaimer
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Jika mengalami sesak napas berat, nyeri dada, penurunan kesadaran, atau perdarahan berat, segera ke fasilitas kesehatan terdekat.',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.red[700], height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
              if (_recent.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text('Konsultasi Terbaru', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                ..._recent.map((c) => ConsultationCard(
                  consultation: c,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ConsultationDetailScreen(consultation: c))),
                )),
              ] else ...[
                const SizedBox(height: 24),
                EmptyStateWidget(
                  title: 'Belum Ada Konsultasi',
                  subtitle: 'Anda belum pernah mengajukan konsultasi. Buat konsultasi baru untuk mulai.',
                  icon: Icons.chat_bubble_outline,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
