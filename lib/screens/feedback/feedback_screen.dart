import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _msgCtrl = TextEditingController();
  
  String _selectedCategory = 'Pelayanan';
  int _rating = 5;
  bool _submitting = false;

  final List<String> _categories = ['Pelayanan', 'Fasilitas', 'Informasi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (session != null && session['name'] != null) {
      setState(() {
        _nameCtrl.text = session['name'];
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);
    // Simulate API request
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _submitting = false);

    // Show success dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF2E7D32)),
            const SizedBox(width: 8),
            Text(
              'Terima Kasih!',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          'Masukan Anda berhasil dikirimkan. Masukan Anda sangat berharga bagi peningkatan pelayanan di Puskesmas Silangit.',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back
            },
            child: Text(
              'Selesai',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF2E7D32)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Masukan'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bantu Kami Meningkatkan Layanan',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 6),
              Text(
                'Setiap kritik, saran, maupun apresiasi dari Anda akan ditindaklanjuti untuk kualitas Puskesmas Silangit yang lebih baik.',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600], height: 1.4),
              ),
              const SizedBox(height: 24),

              // Category selector
              Text(
                'Kategori Masukan',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 8),
              Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFF2E7D32) : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? const Color(0xFF2E7D32) : Colors.grey[300]!,
                          ),
                          boxShadow: isSelected
                              ? [BoxShadow(color: const Color(0xFF2E7D32).withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]
                              : [],
                        ),
                        child: Text(
                          cat,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Rating input
              Text(
                'Tingkat Kepuasan',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  final starVal = index + 1;
                  return IconButton(
                    icon: Icon(
                      starVal <= _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 38,
                    ),
                    onPressed: () => setState(() => _rating = starVal),
                  );
                }),
              ),
              Center(
                child: Text(
                  _rating == 5
                      ? 'Sangat Puas'
                      : _rating == 4
                          ? 'Puas'
                          : _rating == 3
                              ? 'Cukup Puas'
                              : _rating == 2
                                  ? 'Kurang Puas'
                                  : 'Sangat Kecewa',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
              ),
              const SizedBox(height: 20),

              // Name field
              Text(
                'Nama Pengirim',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Nama Anda (Bisa dikosongkan untuk Anonim)',
                  prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF2E7D32)),
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 16),

              // Message field
              Text(
                'Pesan / Masukan',
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _msgCtrl,
                maxLines: 5,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Tuliskan kritik, saran, atau masukan Anda di sini...',
                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Pesan masukan tidak boleh kosong' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitting ? null : _submitFeedback,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _submitting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(
                          'Kirim Masukan',
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
