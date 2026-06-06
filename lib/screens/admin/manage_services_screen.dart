import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/service_model.dart';

class ManageServicesScreen extends StatefulWidget {
  const ManageServicesScreen({super.key});

  @override
  State<ManageServicesScreen> createState() => _ManageServicesScreenState();
}

class _ManageServicesScreenState extends State<ManageServicesScreen> {
  late List<ServiceModel> _services;

  @override
  void initState() {
    super.initState();
    _services = List.from(DummyData.services);
  }

  void _showServiceForm([ServiceModel? service]) {
    final nameCtrl = TextEditingController(text: service?.name ?? '');
    final codeCtrl = TextEditingController(text: service?.queueCode ?? '');
    final descCtrl = TextEditingController(text: service?.description ?? '');
    final reqCtrl = TextEditingController(text: service?.requirements ?? '');
    final estCtrl = TextEditingController(text: service?.estimatedTime ?? '');
    final noteCtrl = TextEditingController(text: service?.note ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service == null ? 'Tambah Layanan Baru' : 'Sunting Layanan',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nama Layanan (Poli)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: codeCtrl,
                decoration: const InputDecoration(labelText: 'Kode Antrean (Contoh: A, G, K)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: descCtrl,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Deskripsi Layanan'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: reqCtrl,
                decoration: const InputDecoration(labelText: 'Persyaratan Dokumen'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: estCtrl,
                decoration: const InputDecoration(labelText: 'Estimasi Waktu Layanan (Contoh: 30 menit)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Catatan Khusus'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
                  onPressed: () {
                    if (nameCtrl.text.isEmpty || codeCtrl.text.isEmpty) return;

                    setState(() {
                      if (service == null) {
                        _services.add(
                          ServiceModel(
                            id: 's0${_services.length + 1}',
                            name: nameCtrl.text.trim(),
                            iconCode: 0xe3c8, // default local_hospital icon
                            description: descCtrl.text.trim(),
                            requirements: reqCtrl.text.trim(),
                            estimatedTime: estCtrl.text.trim(),
                            note: noteCtrl.text.trim(),
                            queueCode: codeCtrl.text.toUpperCase().trim(),
                          ),
                        );
                      } else {
                        final idx = _services.indexWhere((s) => s.id == service.id);
                        if (idx != -1) {
                          _services[idx] = ServiceModel(
                            id: service.id,
                            name: nameCtrl.text.trim(),
                            iconCode: service.iconCode,
                            description: descCtrl.text.trim(),
                            requirements: reqCtrl.text.trim(),
                            estimatedTime: estCtrl.text.trim(),
                            note: noteCtrl.text.trim(),
                            queueCode: codeCtrl.text.toUpperCase().trim(),
                          );
                        }
                      }
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          service == null ? 'Layanan berhasil ditambahkan!' : 'Perubahan layanan berhasil disimpan!',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        backgroundColor: const Color(0xFF6A1B9A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(service == null ? 'Tambah' : 'Simpan Perubahan'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteService(String id) {
    setState(() {
      _services.removeWhere((s) => s.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Layanan berhasil dihapus.', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Layanan Poli'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A1B9A),
        onPressed: () => _showServiceForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _services.isEmpty
          ? Center(
              child: Text(
                'Tidak ada layanan yang terdaftar.',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _services.length,
              itemBuilder: (context, index) {
                final service = _services[index];
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
                          Expanded(
                            child: Text(
                              service.name,
                              style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6A1B9A).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Kode: ${service.queueCode}',
                              style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        service.description,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Estimasi Waktu: ${service.estimatedTime}',
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey[750]),
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                            onPressed: () => _showServiceForm(service),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Hapus Layanan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                  content: Text('Apakah Anda yakin ingin menghapus layanan "${service.name}"?', style: GoogleFonts.poppins(fontSize: 13)),
                                  actions: [
                                    TextButton(
                                      child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
                                      onPressed: () => Navigator.pop(ctx),
                                    ),
                                    TextButton(
                                      child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                                      onPressed: () {
                                        Navigator.pop(ctx);
                                        _deleteService(service.id);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
