import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../utils/storage.dart';
import '../register/register_screen.dart';
import '../profil/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool loading = false;

  final Color primaryDark = Color(0xFF133E87);
  final Color primaryLight = Color(0xFF608BC1);
  final Color backgroundSoft = Color(0xFFE8F1FA);

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final resp = await ApiService.login(_email.text.trim(), _pass.text);
    setState(() => loading = false);

    if (resp['ok'] == true) {
      await Storage.saveUser(resp['user']);
      await Storage.saveToken(resp['token']);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ProfileScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundSoft,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ======= WELCOME SECTION =======
                SizedBox(height: 10),
                Icon(
                  Icons.account_circle_rounded,
                  size: 90,
                  color: primaryDark,
                ),
                SizedBox(height: 10),

                Text(
                  "Selamat Datang",
                  style: TextStyle(
                    color: primaryDark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),

                Text(
                  "Silakan login untuk melanjutkan",
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),

                SizedBox(height: 30),

                // ======= LOGIN CARD =======
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: "Email / Username",
                            prefixIcon: Icon(Icons.person, color: primaryDark),
                            filled: true,
                            fillColor: Color(0xFFF4F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Email wajib diisi" : null,
                        ),

                        SizedBox(height: 15),

                        // Password
                        TextFormField(
                          controller: _pass,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(Icons.lock, color: primaryDark),
                            filled: true,
                            fillColor: Color(0xFFF4F7FB),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) =>
                              v!.isEmpty ? "Password wajib diisi" : null,
                        ),

                        SizedBox(height: 25),

                        // ===== LOGIN BUTTON =====
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryDark,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              elevation: 4,
                            ),
                            child: loading
                                ? CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            "Buat akun baru",
                            style: TextStyle(
                              color: primaryDark,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
