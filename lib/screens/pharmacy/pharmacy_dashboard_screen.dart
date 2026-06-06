import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';

class PharmacyDashboardScreen extends StatefulWidget {
  const PharmacyDashboardScreen({super.key});

  @override
  State<PharmacyDashboardScreen> createState() => _PharmacyDashboardScreenState();
}

class _PharmacyDashboardScreenState extends State<PharmacyDashboardScreen> with SingleTickerProviderStateMixin {
  String _pharmacistName = 'Apoteker';
  late TabController _tabCtrl;
  
  // Mock prescription list
  late List<Map<String, dynamic>> _prescriptions;
  late List<Map<String, String>> _medicines;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadData();
    
    // Initialize mock prescriptions
    _prescriptions = [
      {
        'id': 'pr001',
        'ticketNum': 'F-012',
        'patientName': 'Budi Siregar',
        'doctor': 'dr. Sari Simanjuntak',
        'medicines': ['Paracetamol 500mg (3x1)', 'Amoksisilin 500mg (3x1)'],
        'status': 'Menyiapkan', // Menyiapkan, Siap Diambil, Selesai
        'time': '10 menit yang lalu',
      },
      {
        'id': 'pr002',
        'ticketNum': 'F-013',
        'patientName': 'Dewi Situmorang',
        'doctor': 'dr. Maria Panggabean',
        'medicines': ['Cetirizine 10mg (1x1)', 'Vitamin C 500mg (1x1)'],
        'status': 'Siap Diambil',
        'time': '25 menit yang lalu',
      },
      {
        'id': 'pr003',
        'ticketNum': 'F-014',
        'patientName': 'Sinta Manalu',
        'doctor': 'drg. Budi Hutabarat',
        'medicines': ['Antasida tablet (3x1 dikunyah)', 'Paracetamol 500mg (3x1 jika nyeri)'],
        'status': 'Selesai',
        'time': '1 jam yang lalu',
      },
    ];

    _medicines = List.from(DummyData.medicines);
  }

  void _loadData() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (!mounted) return;
    setState(() {
      _pharmacistName = session != null ? (session['name'] ?? 'Apoteker') : 'Apoteker';
    });
  }

  Future<void> _logout() async {
    await LocalStorageHelper.clearLoginSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  void _updatePrescriptionStatus(String id, String newStatus) {
    setState(() {
      final idx = _prescriptions.indexWhere((p) => p['id'] == id);
      if (idx != -1) {
        _prescriptions[idx]['status'] = newStatus;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Status resep diperbarui ke: $newStatus', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: const Color(0xFF00695C),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Farmasi'),
        backgroundColor: const Color(0xFF00695C), // Teal for Pharmacy
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'Antrean Resep'),
            Tab(text: 'Informasi Obat'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Keluar Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text('Apakah Anda yakin ingin keluar dari portal farmasi?', style: GoogleFonts.poppins(fontSize: 13)),
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
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          // TAB 1: Prescription queues
          _buildPrescriptionsTab(),

          // TAB 2: Medicines Info lookup
          _buildMedicinesTab(),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return Column(
      children: [
        // Welcome bar
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF00695C).withOpacity(0.1),
                child: const Icon(Icons.medication, color: Color(0xFF00695C)),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Petugas Farmasi,', style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600])),
                  Text(_pharmacistName, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        // Listing
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _prescriptions.length,
            itemBuilder: (context, index) {
              final pr = _prescriptions[index];
              final status = pr['status'] as String;
              
              Color statusColor = Colors.orange;
              if (status == 'Siap Diambil') statusColor = Colors.blue;
              if (status == 'Selesai') statusColor = Colors.green;

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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00695C).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            pr['ticketNum'],
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF00695C)),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      pr['patientName'],
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Resep dari: ${pr['doctor']} (${pr['time']})',
                      style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    Text(
                      'Daftar Obat:',
                      style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[750]),
                    ),
                    ...(pr['medicines'] as List<String>).map((med) => Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text('• $med', style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87)),
                    )),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Divider(height: 1),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (status == 'Menyiapkan') ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Tandai Siap'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _updatePrescriptionStatus(pr['id'], 'Siap Diambil'),
                          ),
                        ],
                        if (status == 'Siap Diambil') ...[
                          ElevatedButton.icon(
                            icon: const Icon(Icons.done_all, size: 16),
                            label: const Text('Serahkan Obat'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                            onPressed: () => _updatePrescriptionStatus(pr['id'], 'Selesai'),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMedicinesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _medicines.length,
      itemBuilder: (context, index) {
        final med = _medicines[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    med['name'] ?? '',
                    style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF00695C)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      med['category'] ?? '',
                      style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Fungsi/Indikasi:',
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[850]),
              ),
              Text(
                med['usage'] ?? '',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                'Dosis Lazim:',
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[850]),
              ),
              Text(
                med['dose'] ?? '',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 8),
              Text(
                'Pemberitahuan/Efek Samping:',
                style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[850]),
              ),
              Text(
                med['note'] ?? '',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[700], fontStyle: FontStyle.italic),
              ),
            ],
          ),
        );
      },
    );
  }
}
