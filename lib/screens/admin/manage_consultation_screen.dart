import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/consultation_model.dart';

class ManageConsultationScreen extends StatefulWidget {
  const ManageConsultationScreen({super.key});

  @override
  State<ManageConsultationScreen> createState() => _ManageConsultationScreenState();
}

class _ManageConsultationScreenState extends State<ManageConsultationScreen> {
  late List<ConsultationModel> _consultations;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _consultations = List.from(DummyData.dummyConsultations);
  }

  void _deleteConsultation(String id) {
    setState(() {
      _consultations.removeWhere((c) => c.id == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Konsultasi berhasil dihapus.', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<ConsultationModel> get _filteredConsultations {
    if (_selectedFilter == 'Menunggu') {
      return _consultations.where((c) => c.status == ConsultationStatus.waiting).toList();
    } else if (_selectedFilter == 'Terjawab') {
      return _consultations.where((c) => c.status == ConsultationStatus.answered).toList();
    }
    return _consultations;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredConsultations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Konsultasi'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Column(
        children: [
          // Filter Row
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Semua', 'Menunggu', 'Terjawab'].map((filter) {
                final isSel = _selectedFilter == filter;
                return ChoiceChip(
                  label: Text(filter),
                  selected: isSel,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedFilter = filter);
                  },
                  selectedColor: const Color(0xFF6A1B9A).withOpacity(0.15),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    color: isSel ? const Color(0xFF6A1B9A) : Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // List Items
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak Ada Konsultasi',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final con = filtered[index];
                      final isAnswered = con.status == ConsultationStatus.answered;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  con.consultationCode,
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isAnswered ? Colors.green.withOpacity(0.12) : Colors.orange.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    isAnswered ? 'Terjawab' : 'Menunggu Jawaban',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: isAnswered ? Colors.green[850] : Colors.orange[850],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              con.patientName,
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              'Keluhan Utama: ${con.mainComplaint} (${con.age} tahun, ${con.gender})',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: con.symptoms.map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  s,
                                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[800]),
                                ),
                              )).toList(),
                            ),
                            if (isAnswered) ...[
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8),
                                child: Divider(height: 1),
                              ),
                              Text(
                                'Dijawab oleh: ${con.answeredBy}',
                                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              ),
                              Text(
                                'Jawaban: ${con.medicalAnswer}',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Divider(height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: Text('Hapus Konsultasi', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                        content: Text('Apakah Anda yakin ingin menghapus tiket konsultasi ini?', style: GoogleFonts.poppins(fontSize: 13)),
                                        actions: [
                                          TextButton(
                                            child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
                                            onPressed: () => Navigator.pop(ctx),
                                          ),
                                          TextButton(
                                            child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                                            onPressed: () {
                                              Navigator.pop(ctx);
                                              _deleteConsultation(con.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
