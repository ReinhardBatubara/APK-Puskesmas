import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/service_model.dart';
import '../../widgets/custom_button.dart';
import '../queue/queue_screen.dart';
import '../consultation/consultation_form_screen.dart';

class ServiceDetailScreen extends StatelessWidget {
  final ServiceModel service;
  const ServiceDetailScreen({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(service.name)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF2E7D32).withOpacity(0.08), const Color(0xFF1976D2).withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.12), shape: BoxShape.circle),
                      child: Icon(IconData(service.iconCode, fontFamily: 'MaterialIcons'), color: const Color(0xFF2E7D32), size: 44),
                    ),
                    const SizedBox(height: 16),
                    Text(service.name, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFF1976D2).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                      child: Text('Kode Antrean: ${service.queueCode}',
                          style: GoogleFonts.poppins(fontSize: 13, color: const Color(0xFF1976D2), fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _buildSection('Deskripsi Layanan', service.description, Icons.info_outline),
              _buildSection('Persyaratan', service.requirements, Icons.checklist_outlined),
              _buildSection('Estimasi Waktu', service.estimatedTime, Icons.schedule_outlined),
              _buildSection('Catatan Penting', service.note, Icons.warning_amber_outlined, noteColor: Colors.amber[700]),
              const SizedBox(height: 24),
              CustomButton(
                label: 'Ambil Nomor Antrean',
                icon: Icons.queue,
                width: double.infinity,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => QueueScreen(preselectedService: service))),
              ),
              const SizedBox(height: 12),
              CustomButton(
                label: 'Konsultasi Terkait Layanan',
                icon: Icons.chat_bubble_outline,
                isOutlined: true,
                width: double.infinity,
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ConsultationFormScreen(preselectedService: service.name))),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon, {Color? noteColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: noteColor ?? const Color(0xFF2E7D32)),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: noteColor ?? const Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.5)),
        ],
      ),
    );
  }
}
