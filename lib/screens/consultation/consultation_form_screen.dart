import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../models/consultation_model.dart';
import 'consultation_detail_screen.dart';

class ConsultationFormScreen extends StatefulWidget {
  final String? preselectedService;
  const ConsultationFormScreen({super.key, this.preselectedService});

  @override
  State<ConsultationFormScreen> createState() => _ConsultationFormScreenState();
}

class _ConsultationFormScreenState extends State<ConsultationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _complaintCtrl = TextEditingController();
  final _historyCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  String? _gender;
  String? _targetService;
  String? _duration;
  final List<String> _selectedSymptoms = [];
  bool _loading = false;

  final List<String> _genders = ['Laki-laki', 'Perempuan'];
  final List<String> _services = ['Poli Umum', 'Poli Gigi', 'KIA', 'Gizi', 'Lansia'];
  final List<String> _durations = ['Kurang dari 1 hari', '1 sampai 3 hari', 'Lebih dari 3 hari', 'Lebih dari 1 minggu'];
  final List<String> _symptoms = ['Demam', 'Batuk', 'Pilek', 'Sakit kepala', 'Mual', 'Sesak napas', 'Nyeri perut', 'Lemas', 'Tidak ada'];

  @override
  void initState() {
    super.initState();
    if (widget.preselectedService != null) _targetService = widget.preselectedService;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_gender == null) { _showError('Jenis kelamin wajib dipilih'); return; }
    if (_targetService == null) { _showError('Layanan tujuan wajib dipilih'); return; }
    if (_duration == null) { _showError('Lama keluhan wajib dipilih'); return; }

    setState(() => _loading = true);
    final consultations = await LocalStorageHelper.getConsultations();
    final count = consultations.length + 1;
    final code = 'KSL-${count.toString().padLeft(3, '0')}';
    final session = await LocalStorageHelper.getLoginSession();

    final newConsult = ConsultationModel(
      id: 'c_${DateTime.now().millisecondsSinceEpoch}',
      consultationCode: code,
      patientName: _nameCtrl.text.trim(),
      age: int.tryParse(_ageCtrl.text.trim()) ?? 0,
      gender: _gender!,
      phone: _phoneCtrl.text.trim().isEmpty ? null : _phoneCtrl.text.trim(),
      targetService: _targetService!,
      mainComplaint: _complaintCtrl.text.trim(),
      complaintDuration: _duration!,
      symptoms: List.from(_selectedSymptoms),
      medicalHistory: _historyCtrl.text.trim().isEmpty ? null : _historyCtrl.text.trim(),
      additionalNote: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
      status: ConsultationStatus.waiting,
      createdAt: DateTime.now(),
      createdBy: session?['id'],
    );

    consultations.add(newConsult.toJson());
    await LocalStorageHelper.saveConsultations(consultations);

    if (!mounted) return;
    setState(() => _loading = false);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 64, height: 64,
              decoration: BoxDecoration(color: const Color(0xFF2E7D32).withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 36)),
            const SizedBox(height: 16),
            Text('Konsultasi Terkirim!', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Konsultasi berhasil dikirim. Tenaga medis akan meninjau keluhan Anda.',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text('Kode: $code', style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700, color: const Color(0xFF6A1B9A))),
          ],
        ),
        actions: [
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => ConsultationDetailScreen(consultation: newConsult)));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white),
              child: Text('Lihat Detail', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
            )),
        ],
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: GoogleFonts.poppins()),
          backgroundColor: Colors.red[700], behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))));
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _ageCtrl.dispose(); _phoneCtrl.dispose();
    _complaintCtrl.dispose(); _historyCtrl.dispose(); _noteCtrl.dispose();
    super.dispose();
  }

  Widget _label(String text, {bool required = false}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: RichText(text: TextSpan(
      text: text,
      style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E)),
      children: required ? [TextSpan(text: ' *', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w700))] : [],
    )),
  );

  Widget _textField(TextEditingController ctrl, String hint, {TextInputType? type, String? Function(String?)? validator, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl, keyboardType: type, maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 13),
      decoration: InputDecoration(hintText: hint, hintStyle: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      validator: validator,
    );
  }

  Widget _dropdown<T>(String hint, T? value, List<T> items, ValueChanged<T?> onChanged, {String? Function(T?)? validator}) {
    return DropdownButtonFormField<T>(
      value: value, hint: Text(hint, style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey)),
      decoration: const InputDecoration(),
      items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString(), style: GoogleFonts.poppins(fontSize: 13)))).toList(),
      onChanged: onChanged, validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulir Konsultasi')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _label('Nama Pasien', required: true),
                _textField(_nameCtrl, 'Masukkan nama lengkap', validator: (v) => (v == null || v.trim().isEmpty) ? 'Nama tidak boleh kosong' : null),
                const SizedBox(height: 14),
                Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Umur', required: true),
                    _textField(_ageCtrl, 'Tahun', type: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Wajib diisi';
                          if (int.tryParse(v) == null) return 'Harus angka';
                          return null;
                        }),
                  ])),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    _label('Jenis Kelamin', required: true),
                    _dropdown('Pilih', _gender, _genders, (v) => setState(() => _gender = v)),
                  ])),
                ]),
                const SizedBox(height: 14),
                _label('Nomor HP (opsional)'),
                _textField(_phoneCtrl, 'Contoh: 08123456789', type: TextInputType.phone),
                const SizedBox(height: 14),
                _label('Layanan Tujuan', required: true),
                _dropdown('Pilih layanan', _targetService, _services, (v) => setState(() => _targetService = v)),
                const SizedBox(height: 14),
                _label('Keluhan Utama', required: true),
                _textField(_complaintCtrl, 'Jelaskan keluhan utama Anda', maxLines: 3,
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Keluhan utama wajib diisi' : null),
                const SizedBox(height: 14),
                _label('Lama Keluhan', required: true),
                _dropdown('Pilih durasi', _duration, _durations, (v) => setState(() => _duration = v)),
                const SizedBox(height: 14),
                _label('Gejala Tambahan'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Wrap(
                    spacing: 6, runSpacing: 6,
                    children: _symptoms.map((s) {
                      final selected = _selectedSymptoms.contains(s);
                      return FilterChip(
                        label: Text(s, style: GoogleFonts.poppins(fontSize: 12, color: selected ? Colors.white : const Color(0xFF1A1A2E))),
                        selected: selected,
                        onSelected: (val) => setState(() {
                          if (val) _selectedSymptoms.add(s);
                          else _selectedSymptoms.remove(s);
                        }),
                        selectedColor: const Color(0xFF2E7D32),
                        backgroundColor: Colors.grey[100],
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                _label('Riwayat Penyakit (opsional)'),
                _textField(_historyCtrl, 'Contoh: Diabetes, Hipertensi', maxLines: 2),
                const SizedBox(height: 14),
                _label('Catatan Tambahan (opsional)'),
                _textField(_noteCtrl, 'Informasi tambahan yang ingin disampaikan', maxLines: 3),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _loading ? null : _submit,
                    icon: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send_outlined),
                    label: Text(_loading ? 'Mengirim...' : 'Kirim Konsultasi', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32), foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
