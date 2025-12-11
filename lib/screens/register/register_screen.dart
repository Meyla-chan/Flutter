import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../login/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  String _role = 'mahasiswa';
  bool _loading = false;

  // THEME
  final Color primaryDark = Color(0xFF133E87);
  final Color primaryLight = Color(0xFF608BC1);
  final Color backgroundSoft = Color(0xFFE8F1FA);

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final user = {
      "name": _nameCtrl.text.trim(),
      "email": _emailCtrl.text.trim(),
      "password": _passwordCtrl.text.trim(),
      "role": _role,
    };

    await Storage.saveUser(user);
    await Storage.saveToken("dummy-token");

    setState(() => _loading = false);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Registrasi berhasil!")));

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    Storage.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                // ================= HEADER ==================
                Icon(Icons.person_add_alt_1, size: 90, color: primaryDark),
                SizedBox(height: 10),

                Text(
                  "Buat Akun Baru",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: primaryDark,
                  ),
                ),

                SizedBox(height: 30),

                // ================= FORM CARD =================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.08),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _inputField(
                          controller: _nameCtrl,
                          hint: "Nama Lengkap",
                          icon: Icons.person,
                          validator: (v) =>
                              v!.isEmpty ? "Nama wajib diisi" : null,
                        ),

                        SizedBox(height: 14),

                        _inputField(
                          controller: _emailCtrl,
                          hint: "Email",
                          icon: Icons.email,
                          validator: (v) =>
                              v!.isEmpty ? "Email wajib diisi" : null,
                        ),

                        SizedBox(height: 14),

                        _inputField(
                          controller: _passwordCtrl,
                          hint: "Password",
                          icon: Icons.lock,
                          obscure: true,
                          validator: (v) =>
                              (v!.length < 4) ? "Minimal 4 karakter" : null,
                        ),

                        SizedBox(height: 14),

                        _inputField(
                          controller: _confirmCtrl,
                          hint: "Konfirmasi Password",
                          icon: Icons.lock_outline,
                          obscure: true,
                          validator: (v) {
                            if (v!.isEmpty) return "Konfirmasi password";
                            if (v != _passwordCtrl.text)
                              return "Password tidak sama";
                            return null;
                          },
                        ),

                        SizedBox(height: 14),

                        // ================= ROLE DROPDOWN =================
                        DropdownButtonFormField<String>(
                          value: _role,
                          decoration: _inputDecoration(),
                          items: [
                            DropdownMenuItem(
                              value: "mahasiswa",
                              child: Text("Mahasiswa"),
                            ),
                            DropdownMenuItem(
                              value: "dosen",
                              child: Text("Dosen"),
                            ),
                            DropdownMenuItem(
                              value: "admin_prodi",
                              child: Text("Admin Prodi"),
                            ),
                            DropdownMenuItem(
                              value: "admin_poli",
                              child: Text("Admin Poli"),
                            ),
                          ],
                          onChanged: (v) => setState(() => _role = v!),
                        ),

                        SizedBox(height: 24),

                        // ================= BUTTON =================
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _signup,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryDark,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    "Daftar",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 14),

                        // ================= LOGIN LINK =================
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text(
                            "Sudah punya akun? Login",
                            style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w600,
                            ),
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
      ),
    );
  }

  // ================= INPUT FIELD =================
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: _inputDecoration().copyWith(
        hintText: hint,
        prefixIcon: Icon(icon, color: primaryDark),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Color(0xFFF1F6FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
