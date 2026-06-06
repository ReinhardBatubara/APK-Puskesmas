import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/queue_model.dart';
import '../../models/service_model.dart';

class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  String _officerName = 'Petugas';
  late List<QueueModel> _queues;
  final _formKey = GlobalKey<FormState>();
  
  final _patientNameCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _complaintCtrl = TextEditingController();
  String _selectedPatientType = 'Umum';
  ServiceModel? _selectedService;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (!mounted) return;
    setState(() {
      _officerName = session != null ? (session['name'] ?? 'Petugas') : 'Petugas';
      _queues = List.from(DummyData.dummyQueues);
      _selectedService = DummyData.services.first;
    });
  }

  Future<void> _logout() async {
    await LocalStorageHelper.clearLoginSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _registerWalkInPatient() {
    if (!_formKey.currentState!.validate() || _selectedService == null) return;

    final code = _selectedService!.queueCode;
    final prefixQueues = _queues.where((q) => q.serviceCode == code).toList();
    final nextNum = prefixQueues.length + 1;
    final queueNum = '$code-${nextNum.toString().padLeft(3, '0')}';

    final newTicket = QueueModel(
      id: 'q0${_queues.length + 1}',
      queueNumber: queueNum,
      patientName: _patientNameCtrl.text.trim(),
      nik: _nikCtrl.text.trim().isEmpty ? null : _nikCtrl.text.trim(),
      phone: null,
      serviceName: _selectedService!.name,
      serviceCode: _selectedService!.queueCode,
      patientType: _selectedPatientType,
      complaint: _complaintCtrl.text.trim().isEmpty ? null : _complaintCtrl.text.trim(),
      status: QueueStatus.waiting,
      createdAt: DateTime.now(),
      createdBy: 'officer',
    );

    setState(() {
      _queues.add(newTicket);
    });

    _patientNameCtrl.clear();
    _nikCtrl.clear();
    _complaintCtrl.clear();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.print, color: Color(0xFFE65100)),
            const SizedBox(width: 8),
            Text('Tiket Dicetak!', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE65100).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  newTicket.queueNumber,
                  style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFFE65100)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Nama: ${newTicket.patientName}', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
            Text('Poli: ${newTicket.serviceName}', style: GoogleFonts.poppins(fontSize: 13)),
            Text('Jenis Pasien: ${newTicket.patientType}', style: GoogleFonts.poppins(fontSize: 13)),
            const SizedBox(height: 8),
            Text(
              '*Serahkan tiket ini ke pasien dan arahkan untuk menunggu panggilan poli terkait.',
              style: GoogleFonts.poppins(fontSize: 10, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Selesai', style: GoogleFonts.poppins(color: const Color(0xFFE65100), fontWeight: FontWeight.bold)),
            onPressed: () => Navigator.pop(ctx),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _patientNameCtrl.dispose();
    _nikCtrl.dispose();
    _complaintCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal Pendaftaran'),
        backgroundColor: const Color(0xFFE65100), // Orange for Officer
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Keluar Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text('Apakah Anda yakin ingin keluar dari portal pendaftaran?', style: GoogleFonts.poppins(fontSize: 13)),
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
            // Officer Profile
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFFE65100).withOpacity(0.1),
                  radius: 28,
                  child: const Icon(Icons.badge, color: Color(0xFFE65100), size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Petugas Loket Pendaftaran,',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _officerName,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Form: Register Walk-In Patient
            Text(
              'Registrasi Pasien Mandiri (Walk-In)',
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
                      controller: _patientNameCtrl,
                      decoration: const InputDecoration(labelText: 'Nama Lengkap Pasien'),
                      validator: (v) => (v == null || v.isEmpty) ? 'Nama pasien harus diisi' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _nikCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'NIK (Opsional)'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<ServiceModel>(
                      value: _selectedService,
                      items: DummyData.services.map((s) => DropdownMenuItem(
                        value: s,
                        child: Text('${s.name} (${s.queueCode})', style: GoogleFonts.poppins(fontSize: 13)),
                      )).toList(),
                      onChanged: (val) {
                        setState(() => _selectedService = val);
                      },
                      decoration: const InputDecoration(labelText: 'Poli Tujuan'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedPatientType,
                      items: ['Umum', 'BPJS', 'Lansia', 'Ibu Hamil/Balita'].map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(t, style: GoogleFonts.poppins(fontSize: 13)),
                      )).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedPatientType = val);
                      },
                      decoration: const InputDecoration(labelText: 'Kategori / Pembiayaan'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _complaintCtrl,
                      decoration: const InputDecoration(labelText: 'Keluhan Pasien (Opsional)'),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('Cetak Nomor Antrean'),
                        onPressed: _registerWalkInPatient,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE65100),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Live Queue monitor summary
            Text(
              'Antrean Hari Ini (${_queues.length})',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _queues.length > 5 ? 5 : _queues.length,
              itemBuilder: (context, index) {
                // reverse list to show latest registered first
                final q = _queues[_queues.length - 1 - index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            q.patientName,
                            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Poli: ${q.serviceName}',
                            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE65100).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          q.queueNumber,
                          style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFFE65100)),
                        ),
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
}
