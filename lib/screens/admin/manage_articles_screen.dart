import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/dummy_data.dart';
import '../../models/health_article_model.dart';

class ManageArticlesScreen extends StatefulWidget {
  const ManageArticlesScreen({super.key});

  @override
  State<ManageArticlesScreen> createState() => _ManageArticlesScreenState();
}

class _ManageArticlesScreenState extends State<ManageArticlesScreen> {
  late List<HealthArticleModel> _articles;

  @override
  void initState() {
    super.initState();
    _articles = List.from(DummyData.articles);
  }

  void _showArticleForm([HealthArticleModel? article]) {
    final titleCtrl = TextEditingController(text: article?.title ?? '');
    final summaryCtrl = TextEditingController(text: article?.summary ?? '');
    final catCtrl = TextEditingController(text: article?.category ?? '');
    final timeCtrl = TextEditingController(text: article?.readTime ?? '3 menit');
    final contentCtrl = TextEditingController(text: article?.content ?? '');

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
                article == null ? 'Tulis Artikel Baru' : 'Sunting Artikel',
                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Judul Artikel'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: summaryCtrl,
                decoration: const InputDecoration(labelText: 'Ringkasan / Summary'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: catCtrl,
                decoration: const InputDecoration(labelText: 'Kategori (Contoh: Gizi, Imunisasi, Penyakit)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(labelText: 'Waktu Baca (Contoh: 4 menit)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: contentCtrl,
                maxLines: 6,
                decoration: const InputDecoration(labelText: 'Isi Konten Artikel'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
                  onPressed: () {
                    if (titleCtrl.text.isEmpty || contentCtrl.text.isEmpty) return;

                    setState(() {
                      if (article == null) {
                        _articles.add(
                          HealthArticleModel(
                            id: 'a0${_articles.length + 1}',
                            title: titleCtrl.text.trim(),
                            summary: summaryCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            category: catCtrl.text.trim().isEmpty ? 'Edukasi' : catCtrl.text.trim(),
                            readTime: timeCtrl.text.trim(),
                            publishedDate: DateTime.now(),
                          ),
                        );
                      } else {
                        final idx = _articles.indexWhere((a) => a.id == article.id);
                        if (idx != -1) {
                          _articles[idx] = HealthArticleModel(
                            id: article.id,
                            title: titleCtrl.text.trim(),
                            summary: summaryCtrl.text.trim(),
                            content: contentCtrl.text.trim(),
                            category: catCtrl.text.trim().isEmpty ? 'Edukasi' : catCtrl.text.trim(),
                            readTime: timeCtrl.text.trim(),
                            publishedDate: article.publishedDate,
                          );
                        }
                      }
                    });

                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          article == null ? 'Artikel berhasil diterbitkan!' : 'Perubahan artikel berhasil disimpan!',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        backgroundColor: const Color(0xFF6A1B9A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Text(article == null ? 'Terbitkan' : 'Simpan Perubahan'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteArticle(String id) {
    setState(() {
      _articles.removeWhere((a) => a.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Artikel berhasil dihapus.', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Artikel'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A1B9A),
        onPressed: () => _showArticleForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _articles.isEmpty
          ? Center(
              child: Text(
                'Tidak ada artikel yang diterbitkan.',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _articles.length,
              itemBuilder: (context, index) {
                final article = _articles[index];
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6A1B9A).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          article.category,
                          style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        article.title,
                        style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        article.summary,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Divider(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Waktu Baca: ${article.readTime}',
                            style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500]),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                                onPressed: () => _showArticleForm(article),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Hapus Artikel', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                                      content: Text('Apakah Anda yakin ingin menghapus artikel ini?', style: GoogleFonts.poppins(fontSize: 13)),
                                      actions: [
                                        TextButton(
                                          child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
                                          onPressed: () => Navigator.pop(ctx),
                                        ),
                                        TextButton(
                                          child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            _deleteArticle(article.id);
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
                    ],
                  ),
                );
              },
            ),
    );
  }
}
