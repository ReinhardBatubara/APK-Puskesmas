import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/consultation_model.dart';
import '../../widgets/consultation_card.dart';
import '../../widgets/empty_state_widget.dart';
import 'consultation_detail_screen.dart';

class ConsultationHistoryScreen extends StatefulWidget {
  const ConsultationHistoryScreen({super.key});

  @override
  State<ConsultationHistoryScreen> createState() => _ConsultationHistoryScreenState();
}

class _ConsultationHistoryScreenState extends State<ConsultationHistoryScreen> {
  List<ConsultationModel> _all = [];
  String _filter = 'Semua';
  bool _loading = true;
  String? _userId;

  final List<String> _filters = ['Semua', ConsultationStatus.waiting, ConsultationStatus.answered, ConsultationStatus.done];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final session = await LocalStorageHelper.getLoginSession();
    _userId = session?['id'];
    final raw = await LocalStorageHelper.getConsultations();
    final allData = [...DummyData.dummyConsultations.map((c) => c.toJson()), ...raw];
    List<ConsultationModel> list = allData.map((c) => ConsultationModel.fromJson(c)).toList();
    if (_userId != null) list = list.where((c) => c.createdBy == _userId).toList();
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (!mounted) return;
    setState(() { _all = list; _loading = false; });
  }

  List<ConsultationModel> get _filtered =>
      _filter == 'Semua' ? _all : _all.where((c) => c.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Konsultasi')),
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: _filters.map((f) {
                  final active = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f, style: GoogleFonts.poppins(fontSize: 12, color: active ? Colors.white : const Color(0xFF1A1A2E))),
                      selected: active,
                      onSelected: (_) => setState(() => _filter = f),
                      selectedColor: const Color(0xFF2E7D32),
                      backgroundColor: Colors.grey[100],
                      checkmarkColor: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                      ? EmptyStateWidget(
                          title: 'Tidak Ada Konsultasi',
                          subtitle: 'Belum ada konsultasi dengan filter yang dipilih.',
                          icon: Icons.chat_bubble_outline)
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: ListView(
                            padding: const EdgeInsets.all(16),
                            children: _filtered.map((c) => ConsultationCard(
                              consultation: c,
                              onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) => ConsultationDetailScreen(consultation: c))),
                            )).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
