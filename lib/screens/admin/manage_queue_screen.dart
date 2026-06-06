import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/queue_model.dart';
import '../../widgets/queue_card.dart';

class ManageQueueScreen extends StatefulWidget {
  const ManageQueueScreen({super.key});

  @override
  State<ManageQueueScreen> createState() => _ManageQueueScreenState();
}

class _ManageQueueScreenState extends State<ManageQueueScreen> {
  late List<QueueModel> _queues;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _queues = List.from(DummyData.dummyQueues);
  }

  void _updateStatus(String queueId, String newStatus) {
    setState(() {
      final idx = _queues.indexWhere((q) => q.id == queueId);
      if (idx != -1) {
        final current = _queues[idx];
        _queues[idx] = QueueModel(
          id: current.id,
          queueNumber: current.queueNumber,
          patientName: current.patientName,
          nik: current.nik,
          phone: current.phone,
          serviceName: current.serviceName,
          serviceCode: current.serviceCode,
          patientType: current.patientType,
          complaint: current.complaint,
          status: newStatus,
          createdAt: current.createdAt,
          createdBy: current.createdBy,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status antrean berhasil diperbarui menjadi: ${newStatus.toUpperCase()}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: const Color(0xFF6A1B9A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  List<QueueModel> get _filteredQueues {
    if (_selectedFilter == 'Menunggu') {
      return _queues.where((q) => q.status == QueueStatus.waiting).toList();
    } else if (_selectedFilter == 'Dipanggil') {
      return _queues.where((q) => q.status == QueueStatus.called).toList();
    } else if (_selectedFilter == 'Dilayani') {
      return _queues.where((q) => q.status == QueueStatus.serving).toList();
    } else if (_selectedFilter == 'Selesai') {
      return _queues.where((q) => q.status == QueueStatus.done).toList();
    }
    return _queues;
  }

  int _countByStatus(String status) {
    return _queues.where((q) => q.status == status).toList().length;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredQueues;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Antrean'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      body: Column(
        children: [
          // Stat Counters Panel
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: _buildMiniStat('Menunggu', '${_countByStatus(QueueStatus.waiting)}', Colors.orange),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMiniStat('Dipanggil', '${_countByStatus(QueueStatus.called)}', Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMiniStat('Dilayani', '${_countByStatus(QueueStatus.serving)}', Colors.green),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildMiniStat('Selesai', '${_countByStatus(QueueStatus.done)}', Colors.grey),
                ),
              ],
            ),
          ),
          // Filter Chips Row
          Container(
            height: 50,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: ['Semua', 'Menunggu', 'Dipanggil', 'Dilayani', 'Selesai'].map((status) {
                final isSel = _selectedFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSel,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedFilter = status);
                    },
                    selectedColor: const Color(0xFF6A1B9A).withOpacity(0.15),
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      color: isSel ? const Color(0xFF6A1B9A) : Colors.black87,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Queue Items List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.queue_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak Ada Antrean',
                            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tidak ada antrean dalam filter status $_selectedFilter.',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final queue = filtered[index];
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
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6A1B9A).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    queue.queueNumber,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF6A1B9A),
                                    ),
                                  ),
                                ),
                                _buildStatusBadge(queue.status),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              queue.patientName,
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              'Poli: ${queue.serviceName} (${queue.patientType})',
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                            ),
                            if (queue.complaint != null && queue.complaint!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Keluhan: ${queue.complaint}',
                                style: GoogleFonts.poppins(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                              ),
                            ],
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (queue.status == QueueStatus.waiting) ...[
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.volume_up, size: 16),
                                    label: const Text('Panggil'),
                                    onPressed: () => _updateStatus(queue.id, QueueStatus.called),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                if (queue.status == QueueStatus.called) ...[
                                  OutlinedButton.icon(
                                    icon: const Icon(Icons.replay, size: 16),
                                    label: const Text('Panggil Ulang'),
                                    onPressed: () => _updateStatus(queue.id, QueueStatus.called),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.blue,
                                      side: const BorderSide(color: Colors.blue),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                      textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.play_arrow, size: 16),
                                    label: const Text('Mulai Layani'),
                                    onPressed: () => _updateStatus(queue.id, QueueStatus.serving),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                if (queue.status == QueueStatus.serving) ...[
                                  ElevatedButton.icon(
                                    icon: const Icon(Icons.check, size: 16),
                                    label: const Text('Selesaikan'),
                                    onPressed: () => _updateStatus(queue.id, QueueStatus.done),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[700],
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      textStyle: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
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
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: color),
          ),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 9, color: Colors.grey[700], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg = Colors.grey;
    Color fg = Colors.white;
    String label = 'Menunggu';

    switch (status) {
      case QueueStatus.waiting:
        bg = Colors.orange.withOpacity(0.12);
        fg = Colors.orange[800]!;
        label = 'Menunggu';
        break;
      case QueueStatus.called:
        bg = Colors.blue.withOpacity(0.12);
        fg = Colors.blue[800]!;
        label = 'Dipanggil';
        break;
      case QueueStatus.serving:
        bg = Colors.green.withOpacity(0.12);
        fg = Colors.green[800]!;
        label = 'Dilayani';
        break;
      case QueueStatus.done:
        bg = Colors.grey.withOpacity(0.12);
        fg = Colors.grey[700]!;
        label = 'Selesai';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: fg),
      ),
    );
  }
}
