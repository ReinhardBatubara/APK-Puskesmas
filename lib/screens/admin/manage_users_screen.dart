import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/role_constants.dart';
import '../../core/utils/local_storage_helper.dart';
import '../../data/dummy_accounts.dart';
import '../../models/user_model.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  List<UserModel> _users = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _loading = true);
    
    final dummy = DummyAccounts.allUsers;
    final registered = await LocalStorageHelper.getRegisteredUsers();
    
    final regUsers = registered.map((e) => UserModel.fromJson(e)).toList();

    if (!mounted) return;
    setState(() {
      _users = [...dummy, ...regUsers];
      _loading = false;
    });
  }

  Future<void> _addUser(String name, String email, String password, String role) async {
    final newUser = {
      'id': 'u0${_users.length + 1}',
      'name': name,
      'email': email,
      'password': password,
      'role': role,
      'phone': null,
      'address': null,
    };

    final registered = await LocalStorageHelper.getRegisteredUsers();
    registered.add(newUser);
    await LocalStorageHelper.saveRegisteredUsers(registered);

    await _loadUsers();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Akun baru berhasil didaftarkan!', style: GoogleFonts.poppins(fontSize: 13)),
        backgroundColor: const Color(0xFF6A1B9A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddUserForm() {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    String selectedRole = RoleConstants.medical;

    final roles = [
      RoleConstants.patient,
      RoleConstants.admin,
      RoleConstants.medical,
      RoleConstants.officer,
      RoleConstants.pharmacy,
      RoleConstants.head
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
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
                  'Daftarkan Pengguna Baru',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF6A1B9A)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Alamat Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 14),
                Text(
                  'Peran / Role',
                  style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  items: roles.map((r) => DropdownMenuItem(
                    value: r,
                    child: Text(RoleConstants.getRoleName(r)),
                  )).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setModalState(() => selectedRole = val);
                    }
                  },
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6A1B9A)),
                    onPressed: () {
                      if (nameCtrl.text.isEmpty || emailCtrl.text.isEmpty || passCtrl.text.isEmpty) return;
                      
                      _addUser(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passCtrl.text.trim(),
                        selectedRole,
                      );
                      Navigator.pop(ctx);
                    },
                    child: const Text('Daftarkan'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pengguna'),
        backgroundColor: const Color(0xFF6A1B9A),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6A1B9A),
        onPressed: _showAddUserForm,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF6A1B9A)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final roleColor = RoleConstants.getRoleColor(user.role);
                final roleName = RoleConstants.getRoleName(user.role);
                
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
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: roleColor.withOpacity(0.1),
                        child: Icon(RoleConstants.getRoleIcon(user.role), color: roleColor),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                            Text(
                              user.email,
                              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: roleColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          roleName,
                          style: GoogleFonts.poppins(fontSize: 9, fontWeight: FontWeight.bold, color: roleColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
