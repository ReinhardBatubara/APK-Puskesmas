import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/role_constants.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_accounts.dart';
import '../../data/dummy_data.dart';
import '../../models/user_model.dart';
import '../../core/utils/local_storage_helper.dart' show LocalStorageHelper;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 600));

    UserModel? user = DummyAccounts.findUser(
        _emailCtrl.text.trim(), _passCtrl.text.trim());

    if (user == null) {
      // check registered users
      final registered = await LocalStorageHelper.getRegisteredUsers();
      for (final r in registered) {
        if (r['email'] == _emailCtrl.text.trim() &&
            r['password'] == _passCtrl.text.trim()) {
          user = UserModel.fromJson(r);
          break;
        }
      }
    }

    if (!mounted) return;
    setState(() => _loading = false);

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Email atau password salah',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    await LocalStorageHelper.saveLoginSession(user.toJson());
    if (!mounted) return;

    switch (user.role) {
      case RoleConstants.patient:
        Navigator.pushReplacementNamed(context, '/main');
        break;
      case RoleConstants.admin:
        Navigator.pushReplacementNamed(context, '/admin');
        break;
      case RoleConstants.medical:
        Navigator.pushReplacementNamed(context, '/medical');
        break;
      case RoleConstants.officer:
        Navigator.pushReplacementNamed(context, '/officer');
        break;
      case RoleConstants.pharmacy:
        Navigator.pushReplacementNamed(context, '/pharmacy');
        break;
      case RoleConstants.head:
        Navigator.pushReplacementNamed(context, '/head');
        break;
    }
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF43A047)],
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('assets/images/logo.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('Puskesmas Silangit',
                        style: GoogleFonts.poppins(
                            fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 4),
                    Text('Masuk ke akun Anda',
                        style: GoogleFonts.poppins(
                            fontSize: 13, color: Colors.white.withOpacity(0.85))),
                  ],
                ),
              ),
              // Form
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Email',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Masukkan email Anda',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF2E7D32)),
                          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Email tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 16),
                      Text('Password',
                          style: GoogleFonts.poppins(
                              fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A1A2E))),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: _obscure,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Masukkan password Anda',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF2E7D32)),
                          hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(_obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                color: Colors.grey),
                            onPressed: () => setState(() => _obscure = !_obscure),
                          ),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Password tidak boleh kosong' : null,
                      ),
                      const SizedBox(height: 28),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E7D32),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 3,
                          ),
                          child: _loading
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Text('Masuk',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Belum punya akun? ',
                              style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600])),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/register'),
                            child: Text('Daftar Sekarang',
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF2E7D32))),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.info_outline, size: 14, color: Color(0xFF2E7D32)),
                                const SizedBox(width: 6),
                                Text('Akun Demo',
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, fontWeight: FontWeight.w700,
                                        color: const Color(0xFF2E7D32))),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ...[
                              'pasien@silangit.app / pasien123',
                              'admin@silangit.app / admin123',
                              'dokter@silangit.app / dokter123',
                              'petugas@silangit.app / petugas123',
                              'farmasi@silangit.app / farmasi123',
                              'kepala@silangit.app / kepala123',
                            ].map((s) => Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text('• $s',
                                      style: GoogleFonts.poppins(
                                          fontSize: 10, color: Colors.grey[700])),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
