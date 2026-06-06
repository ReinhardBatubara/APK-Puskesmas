import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_data.dart';
import '../../widgets/dashboard_menu_card.dart';
import 'manage_queue_screen.dart';
import 'manage_consultation_screen.dart';
import 'manage_services_screen.dart';
import 'manage_articles_screen.dart';
import 'manage_users_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String _adminName = 'Administrator';
  int _totalQueues = 0;
  int _totalConsultations = 0;
  int _totalServices = 0;
  int _totalUsers = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final session = await LocalStorageHelper.getLoginSession();
    final registeredUsers = await LocalStorageHelper.getRegisteredUsers();
    
    if (!mounted) return;
    setState(() {
      _adminName = session != null ? (session['name'] ?? 'Admin') : 'Admin';
      _totalQueues = DummyData.dummyQueues.length;
      _totalConsultations = DummyData.dummyConsultations.length;
      _totalServices = DummyData.services.length;
      // dummy accounts + registered accounts
      _totalUsers = 6 + registeredUsers.length; 
    });
  }

  Future<void> _logout() async {
    await LocalStorageHelper.clearLoginSession();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  Widget _buildStatCard(String title, String count, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  count,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ],
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
        title: const Text('Admin Dashboard'),
        backgroundColor: const Color(0xFF6A1B9A), // Purple for Admin
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Keluar Akun', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  content: Text('Apakah Anda yakin ingin keluar dari akun administrator?', style: GoogleFonts.poppins(fontSize: 13)),
                  actions: [
                    TextButton(
                      child: Text('Batal', style: GoogleFonts.poppins(color: Colors.grey)),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                    TextButton(
                      child: Text('Keluar', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.bold)),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _logout();
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6A1B9A).withOpacity(0.1),
                  radius: 26,
                  child: const Icon(Icons.admin_panel_settings, color: Color(0xFF6A1B9A), size: 30),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat Datang,',
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        _adminName,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Statistics Grid
            Text(
              'Statistik Puskesmas',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.2,
              children: [
                _buildStatCard('Total Antrean', '$_totalQueues', Icons.queue, const Color(0xFF2E7D32)),
                _buildStatCard('Konsultasi', '$_totalConsultations', Icons.chat_bubble_outline, const Color(0xFF6A1B9A)),
                _buildStatCard('Layanan Aktif', '$_totalServices', Icons.medical_services_outlined, const Color(0xFF1976D2)),
                _buildStatCard('Total Pengguna', '$_totalUsers', Icons.people_outline, const Color(0xFFE65100)),
              ],
            ),
            const SizedBox(height: 24),

            // Management Menu
            Text(
              'Menu Pengelolaan',
              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.25,
              children: [
                DashboardMenuCard(
                  label: 'Kelola Antrean',
                  icon: Icons.queue,
                  color: const Color(0xFF2E7D32),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageQueueScreen())),
                ),
                DashboardMenuCard(
                  label: 'Kelola Konsultasi',
                  icon: Icons.chat_bubble,
                  color: const Color(0xFF6A1B9A),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageConsultationScreen())),
                ),
                DashboardMenuCard(
                  label: 'Kelola Layanan',
                  icon: Icons.medical_services,
                  color: const Color(0xFF1976D2),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageServicesScreen())),
                ),
                DashboardMenuCard(
                  label: 'Kelola Artikel',
                  icon: Icons.article,
                  color: const Color(0xFF00695C),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageArticlesScreen())),
                ),
                DashboardMenuCard(
                  label: 'Kelola Pengguna',
                  icon: Icons.people,
                  color: const Color(0xFFE65100),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ManageUsersScreen())),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
