import 'package:flutter/material.dart';

class RoleConstants {
  static const String patient = 'patient';
  static const String admin = 'admin';
  static const String medical = 'medical';
  static const String officer = 'officer';
  static const String pharmacy = 'pharmacy';
  static const String head = 'head';

  static String getRoleName(String role) {
    switch (role) {
      case patient:
        return 'Pasien';
      case admin:
        return 'Admin Puskesmas';
      case medical:
        return 'Tenaga Medis';
      case officer:
        return 'Petugas Pendaftaran';
      case pharmacy:
        return 'Petugas Farmasi';
      case head:
        return 'Kepala Puskesmas';
      default:
        return 'Pengguna';
    }
  }

  static Color getRoleColor(String role) {
    switch (role) {
      case patient:
        return const Color(0xFF2E7D32);
      case admin:
        return const Color(0xFF6A1B9A);
      case medical:
        return const Color(0xFF1565C0);
      case officer:
        return const Color(0xFFE65100);
      case pharmacy:
        return const Color(0xFF00695C);
      case head:
        return const Color(0xFFB71C1C);
      default:
        return const Color(0xFF546E7A);
    }
  }

  static IconData getRoleIcon(String role) {
    switch (role) {
      case patient:
        return Icons.person;
      case admin:
        return Icons.admin_panel_settings;
      case medical:
        return Icons.medical_services;
      case officer:
        return Icons.badge;
      case pharmacy:
        return Icons.medication;
      case head:
        return Icons.supervisor_account;
      default:
        return Icons.person;
    }
  }
}
