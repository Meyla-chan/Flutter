import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import 'register_screen.dart';
import 'dashboard_mahasiswa.dart';
import 'dashboard_dosen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool loading = false;

  final Color deepIndigo = Color(0xFF4741A6);
  final Color softBlue = Color(0xFFD9EFF7);
  final Color pastelBlue = Color(0xFF9BBBFC);

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final resp = await ApiService.login(_email.text.trim(), _pass.text);
    setState(() => loading = false);

    if (resp['ok'] == true) {
      final user = resp['user'];
      await Storage.saveUser(user);
      await Storage.saveToken(resp['token']);

      final role = user['role'];
      if (role == 'mahasiswa') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardMahasiswa()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => DashboardDosen()),
        );
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login gagal")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 160,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [pastelBlue, deepIndigo]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    "Welcome!",
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: 380,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _pass,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (v) => v!.isEmpty ? "Required" : null,
                      ),
                      SizedBox(height: 18),
                      ElevatedButton(
                        onPressed: loading ? null : _login,
                        child: loading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text("Login"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterScreen()),
                        ),
                        child: Text("Buat akun"),
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
