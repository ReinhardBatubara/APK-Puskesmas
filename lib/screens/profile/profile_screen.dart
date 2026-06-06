import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/info_tile.dart';
import '../../widgets/app_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Puskesmas')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80, height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.local_hospital, size: 44, color: Colors.white),
                    ),
                    const SizedBox(height: 14),
                    Text(AppConstants.facilityName,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(AppConstants.category,
                          style: GoogleFonts.poppins(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text('${AppConstants.rating}',
                            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                        Text(' / 5.0 • ${AppConstants.reviewCount} ulasan',
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.white.withOpacity(0.85))),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Kontak', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    InfoTile(icon: Icons.location_on_outlined, label: 'Alamat Lengkap', value: AppConstants.fullAddress),
                    const Divider(height: 1),
                    InfoTile(icon: Icons.pin_drop_outlined, label: 'Plus Code', value: AppConstants.plusCode),
                    const Divider(height: 1),
                    InfoTile(icon: Icons.phone_outlined, label: 'Nomor Telepon', value: AppConstants.phoneStatus, isAvailable: false),
                    const Divider(height: 1),
                    InfoTile(icon: Icons.schedule_outlined, label: 'Jam Buka', value: AppConstants.openingHoursStatus, isAvailable: false),
                    const Divider(height: 1),
                    InfoTile(icon: Icons.language_outlined, label: 'Website', value: AppConstants.websiteStatus, isAvailable: false),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tentang Kami', style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Text(AppConstants.profileDescription,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[700], height: 1.6)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Data kontak sedang dalam proses pembaruan. Silakan datang langsung ke lokasi untuk informasi lebih lanjut.',
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
    );
  }
}
