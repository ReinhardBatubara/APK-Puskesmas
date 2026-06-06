import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/launcher_helper.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../widgets/section_header.dart';
import '../../widgets/service_card.dart';
import '../../widgets/article_card.dart';
import '../../widgets/role_badge.dart';
import '../services/service_detail_screen.dart';
import '../articles/article_detail_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Pengguna';
  String _userRole = 'patient';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final session = await LocalStorageHelper.getLoginSession();
    if (!mounted) return;
    if (session != null) {
      setState(() {
        _userName = session['name'] ?? 'Pengguna';
        _userRole = session['role'] ?? 'patient';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final popularServices = DummyData.services.take(4).toList();
    final recentArticles = DummyData.articles.take(3).toList();
    final quickActions = DummyData.quickActions;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFF2E7D32),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_outline, color: Colors.white),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            RoleBadge(role: _userRole, small: true),
                            const Spacer(),
                            const Icon(Icons.local_hospital, color: Colors.white70, size: 20),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('Halo, warga Silangit 👋',
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                        Text('Semoga sehat selalu.',
                            style: GoogleFonts.poppins(fontSize: 13, color: Colors.white.withOpacity(0.85))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info Card Puskesmas
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [const Color(0xFF2E7D32).withOpacity(0.08), const Color(0xFF1976D2).withOpacity(0.05)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF2E7D32).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.local_hospital, color: Color(0xFF2E7D32), size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(AppConstants.facilityName,
                                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1976D2).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(AppConstants.category,
                                        style: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFF1976D2), fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text('${AppConstants.rating}',
                                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w700)),
                            Text(' dari ${AppConstants.reviewCount} ulasan',
                                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[500]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(AppConstants.shortAddress,
                                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600])),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Quick Actions
                  Text('Akses Cepat',
                      style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF1A1A2E))),
                  const SizedBox(height: 12),
                  Row(
                    children: List.generate(quickActions.length, (i) {
                      final action = quickActions[i];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (i == 3) {
                              LauncherHelper.openMaps(AppConstants.mapsUrl);
                            } else if (i == 0) {
                              Navigator.pushNamed(context, '/main', arguments: 1);
                            } else if (i == 1) {
                              Navigator.pushNamed(context, '/main', arguments: 2);
                            } else if (i == 2) {
                              Navigator.pushNamed(context, '/main', arguments: 3);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: i < quickActions.length - 1 ? 8 : 0),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  width: 40, height: 40,
                                  decoration: BoxDecoration(
                                    color: (action['color'] as Color).withOpacity(0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(action['icon'] as IconData, color: action['color'] as Color, size: 22),
                                ),
                                const SizedBox(height: 6),
                                Text(action['label'] as String,
                                    style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 24),
                  // Popular Services
                  SectionHeader(
                    title: 'Layanan Populer',
                    actionLabel: 'Lihat Semua',
                    onAction: () => Navigator.pushNamed(context, '/main', arguments: 1),
                  ),
                  const SizedBox(height: 12),
                  ...popularServices.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: ServiceCard(
                          service: s,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: s))),
                        ),
                      )),
                  const SizedBox(height: 20),
                  // Articles
                  SectionHeader(
                    title: 'Artikel Kesehatan',
                    actionLabel: 'Lihat Semua',
                    onAction: () {},
                  ),
                  const SizedBox(height: 12),
                  ...recentArticles.map((a) => ArticleCard(
                        article: a,
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => ArticleDetailScreen(article: a))),
                      )),
                  const SizedBox(height: 16),
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber.withOpacity(0.4)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nomor telepon, jam buka, dan website belum tersedia di Google Maps.',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.amber[900]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
