import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../login/login_screen.dart';
import 'edit_profil_mahasiswa.dart';
import 'edit_profil_dosen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool loading = true;

  final Color primaryDark = Color(0xFF133E87);
  final Color primaryLight = Color(0xFF608BC1);
  final Color backgroundSoft = Color(0xFFE8F1FA);

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() {
    user = Storage.getUser();
    setState(() => loading = false);
  }

  String initials(String name) {
    if (name.trim().isEmpty) return "U";
    final parts = name.trim().split(" ");
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  void goToEdit() async {
    if (user == null) return;

    final role = user!["role"];

    final updated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            role == "mahasiswa" ? EditProfileMahasiswa() : EditProfileDosen(),
      ),
    );

    if (updated == true) {
      loadUser(); // refresh data setelah edit
    }
  }

  void _logout() async {
    await Storage.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final role = user?["role"] ?? "";

    return Scaffold(
      backgroundColor: backgroundSoft,
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // ---------------- HEADER ----------------
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 24, top: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryLight, primaryDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Avatar
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: primaryDark,
                            child: Text(
                              initials(user?["name"] ?? "-"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          user?["name"] ?? "-",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Text(
                          user?["email"] ?? "-",
                          style: TextStyle(color: Colors.white70),
                        ),

                        SizedBox(height: 10),

                        ElevatedButton(
                          onPressed: goToEdit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Edit Profil"),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // ---------------- CONTENT ----------------
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Informasi Akun"),
                          _infoTile("Role", role.toUpperCase()),

                          SizedBox(height: 12),

                          // ==================== DATA MAHASISWA ====================
                          if (role == "mahasiswa") ...[
                            _sectionTitle("Data Mahasiswa"),
                            _infoTile("NIM", user?["nim"]),
                            _infoTile("Program Studi", user?["prodi"]),
                            _infoTile("Fakultas", user?["fakultas"]),
                            _infoTile("Angkatan", user?["angkatan"]),
                            _infoTile("Kelas", user?["kelas"]),
                            _infoTile("Dosen PA", user?["dosen_pa"]),
                            _infoTile("Status", user?["status"]),
                          ],

                          // ==================== DATA DOSEN ====================
                          if (role == "dosen") ...[
                            _sectionTitle("Data Dosen"),
                            _infoTile("NIP/NIDN", user?["nip"]),
                            _infoTile("Jabatan", user?["jabatan"]),
                            _infoTile("Keahlian", user?["keahlian"]),
                            _infoTile("Email", user?["email"]),
                            _infoTile(
                              "Mahasiswa Bimbingan",
                              user?["mahasiswa_bimbingan"] ??
                                  "(belum ada data)",
                            ),
                          ],

                          SizedBox(height: 30),

                          // LOGOUT BUTTON
                          Center(
                            child: ElevatedButton(
                              onPressed: _logout,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[600],
                                padding: EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                "Logout",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ---------------- WIDGETS ----------------

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: primaryDark,
        ),
      ),
    );
  }

  Widget _infoTile(String label, dynamic value) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Text(
            "$label:",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value == null || value.toString().isEmpty
                  ? "-"
                  : value.toString(),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
