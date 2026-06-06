import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/feedback_model.dart';

class HeadDashboardScreen extends StatefulWidget {
  const HeadDashboardScreen({super.key});

  @override
  State<HeadDashboardScreen> createState() => _HeadDashboardScreenState();
}

class _HeadDashboardScreenState extends State<HeadDashboardScreen> {
  String _headName = 'Kepala Puskesmas';
  late List<FeedbackModel> _feedbacks;
  double _avgRating = 4.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final session = await LocalStorageHelper.getLoginSession();
    
    // Calculate stats
    final list = DummyData.dummyFeedbacks;
    double totalRate = 0;
    for (var f in list) {
      totalRate += f.rating;
    }
    
    if (!mounted) return;
    setState(() {
      _headName = session != null ? (session['name'] ?? 'Kepala Puskesmas') : 'Kepala Puskesmas';
      _feedbacks = list;
      if (list.isNotEmpty) {
        _avgRating = double.parse((totalRate / list.length).toStringAsFixed(1));
      }
    });
  }

  Future<void> _logout() async {
    await LocalStorageHelper.clearLoginSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pimpinan'),
        backgroundColor: const Color(0xFFB71C1C), // Deep Red for Head
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Keluar Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text('Apakah Anda yakin ingin keluar dari portal pimpinan?', style: GoogleFonts.poppins(fontSize: 13)),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFB71C1C).withOpacity(0.1),
                  radius: 28,
                  child: const Icon(Icons.supervisor_account, color: Color(0xFFB71C1C), size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Portal Kepala Puskesmas,',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _headName,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Performance metrics row
            Text(
              'Laporan Singkat Kinerja',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 22),
                            const SizedBox(width: 4),
                            Text(
                              '$_avgRating',
                              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kepuasan Pasien',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${DummyData.dummyQueues.length}',
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFB71C1C)),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Kunjungan Hari Ini',
                          style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Distribution graph mockup (Simple bar widgets)
            Text(
              'Distribusi Pasien per Poli',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                children: [
                  _buildMockBar('Poli Umum (A)', 0.65, '14 Pasien', Colors.blue),
                  const SizedBox(height: 10),
                  _buildMockBar('Poli Gigi (G)', 0.25, '5 Pasien', Colors.teal),
                  const SizedBox(height: 10),
                  _buildMockBar('KIA (K)', 0.40, '9 Pasien', Colors.pink),
                  const SizedBox(height: 10),
                  _buildMockBar('Imunisasi (I)', 0.15, '3 Pasien', Colors.purple),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Feedbacks reviews
            Text(
              'Aduan & Saran Warga',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            _feedbacks.isEmpty
                ? Center(child: Text('Belum ada saran masuk.', style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _feedbacks.length,
                    itemBuilder: (context, index) {
                      final fb = _feedbacks[index];
                      final dateStr = DateFormat('dd MMM yyyy').format(fb.createdAt);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  fb.name,
                                  style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: List.generate(5, (sIdx) => Icon(
                                    sIdx < fb.rating ? Icons.star : Icons.star_border,
                                    size: 14,
                                    color: Colors.amber,
                                  )),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Kategori: ${fb.category}',
                                  style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFFB71C1C), fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  dateStr,
                                  style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[500]),
                                ),
                              ],
                            ),
                            const Divider(height: 16),
                            Text(
                              '"${fb.message}"',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700], fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockBar(String title, double fraction, String rightLabel, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500)),
            Text(rightLabel, style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[750])),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
