import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/queue_model.dart';
import '../../models/service_model.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/queue_card.dart';
import 'queue_history_screen.dart';

class QueueScreen extends StatefulWidget {
  final ServiceModel? preselectedService;
  const QueueScreen({super.key, this.preselectedService});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nikCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _complaintCtrl = TextEditingController();
  ServiceModel? _selectedService;
  String? _selectedPatientType;
  bool _loading = false;
  QueueModel? _lastQueue;

  final List<String> _patientTypes = ['Umum', 'BPJS', 'Lansia', 'Anak', 'Ibu Hamil'];

  @override
  void initState() {
    super.initState();
    _selectedService = widget.preselectedService;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final queues = await LocalStorageHelper.getQueues();
    final sameService = queues.where((q) => q['serviceCode'] == _selectedService!.queueCode).length;
    final num = (sameService + 1).toString().padLeft(3, '0');
    final queueNum = '${_selectedService!.queueCode}-$num';
    final session = await LocalStorageHelper.getLoginSession();

    final newQueue = QueueModel(
      id: 'q_${DateTime.now().millisecondsSinceEpoch}',
      queueNumber: queueNum,
      patientName: _nameCtrl.text.trim(),
      nik: _nikCtrl.text.trim().isEmpty ? null : _nikCtrl.text.trim(),
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      serviceName: _selectedService!.name,
      serviceCode: _selectedService!.queueCode,
      patientType: _selectedPatientType!,
      complaint: _complaintCtrl.text.trim().isEmpty ? null : _complaintCtrl.text.trim(),
      status: QueueStatus.waiting,
      createdAt: DateTime.now(),
      createdBy: session?['id'],
    );

    queues.add(newQueue.toJson());
    await LocalStorageHelper.saveQueues(queues);

    if (!mounted) return;
    setState(() { _loading = false; _lastQueue = newQueue; });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nomor antrean $queueNum berhasil dibuat!', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    _formKey.currentState!.reset();
    _nameCtrl.clear(); _nikCtrl.clear(); _phoneCtrl.clear(); _complaintCtrl.clear();
    setState(() { _selectedService = null; _selectedPatientType = null; });
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _nikCtrl.dispose();
    _phoneCtrl.dispose(); _complaintCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambil Nomor Antrean'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Antrean',
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QueueHistoryScreen())),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (_lastQueue != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.confirmation_number, color: Colors.white, size: 32),
                      const SizedBox(height: 8),
                      Text('Nomor Antrean Anda', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      Text(_lastQueue!.queueNumber,
                          style: GoogleFonts.poppins(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900)),
                      Text(_lastQueue!.serviceName, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: Text('Status: ${_lastQueue!.status}',
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Formulir Pendaftaran Antrean',
                          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 16),
                      _field('Nama Pasien *', _nameCtrl, 'Masukkan nama lengkap',
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null),
                      _field('NIK (opsional)', _nikCtrl, 'Nomor Induk Kependudukan', type: TextInputType.number),
                      _field('Nomor HP (opsional)', _phoneCtrl, 'Contoh: 08123456789', type: TextInputType.phone),
                      // Service Dropdown
                      Text('Pilih Layanan *', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E))),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<ServiceModel>(
                        value: _selectedService,
                        hint: Text('Pilih layanan', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                        decoration: InputDecoration(
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        items: DummyData.services.map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name, style: GoogleFonts.poppins(fontSize: 13)),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedService = v),
                        validator: (_) => _selectedService == null ? 'Pilih layanan terlebih dahulu' : null,
                      ),
                      const SizedBox(height: 14),
                      // Patient Type Dropdown
                      Text('Jenis Pasien *', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E))),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _selectedPatientType,
                        hint: Text('Pilih jenis pasien', style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
                        decoration: InputDecoration(
                          filled: true, fillColor: Colors.white,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        items: _patientTypes.map((t) => DropdownMenuItem(
                          value: t, child: Text(t, style: GoogleFonts.poppins(fontSize: 13)),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedPatientType = v),
                        validator: (_) => _selectedPatientType == null ? 'Pilih jenis pasien' : null,
                      ),
                      const SizedBox(height: 14),
                      _field('Keluhan Singkat (opsional)', _complaintCtrl, 'Tuliskan keluhan Anda', maxLines: 3),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _loading ? null : _submit,
                          icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.confirmation_number_outlined),
                          label: Text(_loading ? 'Memproses...' : 'Buat Nomor Antrean', style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w700)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, {String? Function(String?)? validator, TextInputType? type, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E))),
        const SizedBox(height: 6),
        TextFormField(
          controller: ctrl, keyboardType: type, maxLines: maxLines,
          style: GoogleFonts.poppins(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint, hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
            filled: true, fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          validator: validator,
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}
