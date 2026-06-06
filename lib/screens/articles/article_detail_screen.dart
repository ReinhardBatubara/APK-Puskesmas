import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/health_article_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final HealthArticleModel article;
  const ArticleDetailScreen({super.key, required this.article});

  void _shareArticle(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Tautan artikel "${article.title}" disalin ke papan klip!',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildContentBlock(String block) {
    // Basic formatting helper for markdown style text
    if (block.startsWith('**') && block.endsWith('**')) {
      final text = block.substring(2, block.length - 2);
      return Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
        ),
      );
    } else if (block.startsWith('• ')) {
      final text = block.substring(2);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 6, left: 4, right: 8),
              child: Icon(Icons.circle, size: 6, color: Color(0xFF2E7D32)),
            ),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: const Color(0xFF424242)),
              ),
            ),
          ],
        ),
      );
    } else if (block.startsWith('1. ') || block.startsWith('2. ') || block.startsWith('3. ') || block.startsWith('4. ') || block.startsWith('5. ') || block.startsWith('6. ') || block.startsWith('7. ') || block.startsWith('8. ')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 4),
        child: Text(
          block,
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: const Color(0xFF424242)),
        ),
      );
    } else if (block.startsWith('|')) {
      // Very simple table renderer helper or text representation
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          block.replaceAll('|', '   '),
          style: GoogleFonts.poppins(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.black87),
        ),
      );
    } else if (block.startsWith('❌') || block.startsWith('✅') || block.startsWith('⚠️')) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          block,
          style: GoogleFonts.poppins(fontSize: 14, height: 1.5, color: const Color(0xFF424242)),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Text(
          block,
          style: GoogleFonts.poppins(fontSize: 14, height: 1.6, color: const Color(0xFF424242)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Split article content into lines to parse paragraphs and bullet points
    final lines = article.content.split('\n');
    final formattedWidgets = <Widget>[];

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      formattedWidgets.add(_buildContentBlock(trimmed));
    }

    final dateStr = DateFormat('dd MMM yyyy', 'id_ID').format(article.publishedDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        backgroundColor: const Color(0xFF2E7D32),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _shareArticle(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner/Image container
            Container(
              width: double.infinity,
              height: 180,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2E7D32), Color(0xFF1976D2)],
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.health_and_safety_outlined,
                  size: 80,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category tag
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E7D32).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      article.category,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    article.title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Meta Info (Date, Read Time)
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        dateStr,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 14),
                      Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text(
                        article.readTime,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 8),
                  // Summary in bold italics
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8F1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.15)),
                    ),
                    child: Text(
                      article.summary,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF1B5E20),
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Main content
                  ...formattedWidgets,
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
