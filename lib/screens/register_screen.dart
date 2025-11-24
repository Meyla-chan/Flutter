// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'login_screen.dart';

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

  final Color pastelBlue = Color(0xFF9BBBFC);
  final Color deepIndigo = Color(0xFF4741A6);

  void _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final user = {
      'name': _nameCtrl.text.trim(),
      'email': _emailCtrl.text.trim(),
      'password': _passwordCtrl.text,
      'role': _role,
    };

    await Storage.saveUser(user); // save dummy user locally
    // set a dummy token so profile can be viewed
    await Storage.saveToken('dummy-token');

    setState(() => _loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registrasi berhasil. Silakan login.')),
    );

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
      backgroundColor: Color(0xFFD9EFF7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
            child: Column(
              children: [
                // Header small
                Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF9BBBFC), Color(0xFF4741A6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Buat Akun',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                Container(
                  width: 420,
                  padding: EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 14,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Nama / Username',
                            filled: true,
                            fillColor: Color(0xFFF6FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? 'Nama required' : null,
                        ),
                        SizedBox(height: 10),

                        // Email
                        TextFormField(
                          controller: _emailCtrl,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: Color(0xFFF6FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || v.isEmpty)
                              ? 'Email required'
                              : null,
                        ),
                        SizedBox(height: 10),

                        // Password
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: Color(0xFFF6FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) => (v == null || v.length < 4)
                              ? 'Min 4 characters'
                              : null,
                        ),
                        SizedBox(height: 10),

                        // Confirm
                        TextFormField(
                          controller: _confirmCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            filled: true,
                            fillColor: Color(0xFFF6FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Confirm password';
                            if (v != _passwordCtrl.text)
                              return 'Passwords do not match';
                            return null;
                          },
                        ),
                        SizedBox(height: 12),

                        // Role dropdown
                        DropdownButtonFormField<String>(
                          value: _role,
                          items: [
                            DropdownMenuItem(
                              value: 'mahasiswa',
                              child: Text('Mahasiswa'),
                            ),
                            DropdownMenuItem(
                              value: 'dosen',
                              child: Text('Dosen'),
                            ),
                          ],
                          onChanged: (v) =>
                              setState(() => _role = v ?? 'mahasiswa'),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Color(0xFFF6FAFD),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _loading ? null : _signup,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: deepIndigo,
                              elevation: 6,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: _loading
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.bold, // 🔥 lebih tebal
                                      color: Colors.white, // 🔥 lebih kontras
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text(
                            'Back to login',
                            style: TextStyle(color: deepIndigo),
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
}
