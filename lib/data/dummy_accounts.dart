import '../models/user_model.dart';

class DummyAccounts {
  static const List<Map<String, dynamic>> accounts = [
    {
      'id': 'u001',
      'name': 'Pasien Umum',
      'email': 'pasien@silangit.app',
      'password': 'pasien123',
      'role': 'patient',
      'phone': null,
      'address': null,
    },
    {
      'id': 'u002',
      'name': 'Admin Puskesmas',
      'email': 'admin@silangit.app',
      'password': 'admin123',
      'role': 'admin',
      'phone': null,
      'address': null,
    },
    {
      'id': 'u003',
      'name': 'dr. Sari Simanjuntak',
      'email': 'dokter@silangit.app',
      'password': 'dokter123',
      'role': 'medical',
      'phone': null,
      'address': null,
    },
    {
      'id': 'u004',
      'name': 'Petugas Pendaftaran',
      'email': 'petugas@silangit.app',
      'password': 'petugas123',
      'role': 'officer',
      'phone': null,
      'address': null,
    },
    {
      'id': 'u005',
      'name': 'Petugas Farmasi',
      'email': 'farmasi@silangit.app',
      'password': 'farmasi123',
      'role': 'pharmacy',
      'phone': null,
      'address': null,
    },
    {
      'id': 'u006',
      'name': 'Kepala Puskesmas',
      'email': 'kepala@silangit.app',
      'password': 'kepala123',
      'role': 'head',
      'phone': null,
      'address': null,
    },
  ];

  static UserModel? findUser(String email, String password) {
    try {
      final data = accounts.firstWhere(
        (a) => a['email'] == email && a['password'] == password,
      );
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  static List<UserModel> get allUsers {
    return accounts.map((a) => UserModel.fromJson(a)).toList();
  }
}
