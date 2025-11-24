// lib/screens/dashboard_dosen.dart
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class DashboardDosen extends StatelessWidget {
  final Color softBlue = Color(0xFFD9EFF7);
  final Color pastelBlue = Color(0xFF9BBBFC);
  final Color deepIndigo = Color(0xFF4741A6);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBlue,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [pastelBlue, deepIndigo]),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Center(
                child: Text(
                  "Dashboard Dosen",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),

            _menu(context, Icons.people, "Daftar Mahasiswa"),
            _menu(context, Icons.edit_document, "Input Nilai"),
            _menu(context, Icons.check_circle, "Kehadiran"),

            _menu(
              context,
              Icons.person,
              "Profile",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileScreen()),
                );
              },
            ),

            _menu(
              context,
              Icons.logout,
              "Logout",
              onTap: () async {
                await Storage.clear();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
    BuildContext c,
    IconData ic,
    String title, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(ic, color: deepIndigo),
        title: Text(title),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
