import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../models/queue_model.dart';
import '../../widgets/empty_state_widget.dart';
import '../../widgets/queue_card.dart';

class QueueHistoryScreen extends StatefulWidget {
  const QueueHistoryScreen({super.key});

  @override
  State<QueueHistoryScreen> createState() => _QueueHistoryScreenState();
}

class _QueueHistoryScreenState extends State<QueueHistoryScreen> {
  List<QueueModel> _queues = [];
  bool _loading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final session = await LocalStorageHelper.getLoginSession();
    _userId = session?['id'];
    final raw = await LocalStorageHelper.getQueues();
    final all = [...DummyData.dummyQueues.map((q) => q.toJson()), ...raw];
    List<QueueModel> queues = all.map((q) => QueueModel.fromJson(q)).toList();
    if (_userId != null) {
      queues = queues.where((q) => q.createdBy == _userId).toList();
    }
    queues.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (!mounted) return;
    setState(() { _queues = queues; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Antrean')),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _queues.isEmpty
                ? EmptyStateWidget(
                    title: 'Belum Ada Antrean',
                    subtitle: 'Anda belum memiliki riwayat antrean.\nAmbil nomor antrean untuk mulai.',
                    icon: Icons.queue_outlined,
                  )
                : RefreshIndicator(
                    onRefresh: _load,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        Text('${_queues.length} antrean ditemukan',
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                        const SizedBox(height: 12),
                        ..._queues.map((q) => QueueCard(queue: q)),
                      ],
                    ),
                  ),
      ),
    );
  }
}
