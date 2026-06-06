import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/consultation_model.dart';
import 'medical_consultation_detail_screen.dart';

class MedicalDashboardScreen extends StatefulWidget {
  const MedicalDashboardScreen({super.key});

  @override
  State<MedicalDashboardScreen> createState() => _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState extends State<MedicalDashboardScreen> {
  String _doctorName = 'Dokter';
  late List<ConsultationModel> _consultations;
  String _selectedStatus = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (!mounted) return;
    setState(() {
      _doctorName = session != null ? (session['name'] ?? 'Dokter') : 'Dokter';
      _consultations = List.from(DummyData.dummyConsultations);
    });
  }

  Future<void> _logout() async {
    await LocalStorageHelper.clearLoginSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  int _countByStatus(String status) {
    return _consultations.where((c) => c.status == status).length;
  }

  List<ConsultationModel> get _filteredConsultations {
    if (_selectedStatus == 'Menunggu') {
      return _consultations.where((c) => c.status == ConsultationStatus.waiting).toList();
    } else if (_selectedStatus == 'Terjawab') {
      return _consultations.where((c) => c.status == ConsultationStatus.answered).toList();
    }
    return _consultations;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredConsultations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Medis'),
        backgroundColor: const Color(0xFF1565C0), // Blue for Medical
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Keluar Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text('Apakah Anda yakin ingin keluar dari portal medis?', style: GoogleFonts.poppins(fontSize: 13)),
                  actions: [
                    TextButton(
                      child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    TextButton(
                      child: Text('Keluar', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _logout();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Doctor Profile Banner
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF1565C0).withOpacity(0.1),
                  radius: 28,
                  child: const Icon(Icons.medical_services, color: Color(0xFF1565C0), size: 32),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portal Tenaga Medis,',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _doctorName,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Short stats bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF5F5F5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSimpleStat('Menunggu', '${_countByStatus(ConsultationStatus.waiting)}', Colors.orange),
                _buildSimpleStat('Terjawab', '${_countByStatus(ConsultationStatus.answered)}', Colors.green),
                _buildSimpleStat('Total Tiket', '${_consultations.length}', Colors.black87),
              ],
            ),
          ),
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Semua', 'Menunggu', 'Terjawab'].map((status) {
                final isSel = _selectedStatus == status;
                return ChoiceChip(
                  label: Text(status),
                  selected: isSel,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedStatus = status);
                  },
                  selectedColor: const Color(0xFF1565C0).withOpacity(0.15),
                  checkmarkColor: const Color(0xFF1565C0),
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    color: isSel ? const Color(0xFF1565C0) : Colors.black87,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Consultation tickets list
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Tidak Ada Konsultasi',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      final isPending = item.status == ConsultationStatus.waiting;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item.consultationCode,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1565C0),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: isPending ? Colors.orange.withOpacity(0.12) : Colors.green.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      isPending ? 'Menunggu Jawaban' : 'Terjawab',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isPending ? Colors.orange[800] : Colors.green[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.patientName,
                                style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Keluhan: ${item.mainComplaint} (${item.age} tahun, ${item.gender})',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Poli Tujuan: ${item.targetService}',
                                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isPending ? const Color(0xFF1565C0) : Colors.grey[400],
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                    onPressed: () async {
                                      final updated = await Navigator.push<ConsultationModel>(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => MedicalConsultationDetailScreen(consultation: item),
                                        ),
                                      );
                                      if (updated != null) {
                                        setState(() {
                                          final idx = _consultations.indexWhere((c) => c.id == updated.id);
                                          if (idx != -1) {
                                            _consultations[idx] = updated;
                                          }
                                        });
                                      }
                                    },
                                    child: Text(isPending ? 'Jawab Keluhan' : 'Lihat Detail'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStat(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: color),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
