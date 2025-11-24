// lib/screens/dashboard_mahasiswa.dart
import 'package:flutter/material.dart';
import '../utils/storage.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

class DashboardMahasiswa extends StatelessWidget {
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
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [pastelBlue, deepIndigo],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Center(
                child: Text(
                  "Dashboard Mahasiswa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            _menuButton(context, Icons.schedule, "Jadwal Kuliah"),
            _menuButton(context, Icons.school, "Nilai"),
            _menuButton(context, Icons.check_circle, "Kehadiran"),

            _menuButton(
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

            _menuButton(
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

  Widget _menuButton(
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
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
