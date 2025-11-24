// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/storage.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? profile;
  bool loading = true;

  final Color softBlue = Color(0xFFD9EFF7);
  final Color pastelBlue = Color(0xFF9BBBFC);
  final Color deepIndigo = Color(0xFF4741A6);

  @override
  void initState() {
    super.initState();
    Storage.init();
    loadProfile();
  }

  void loadProfile() async {
    setState(() => loading = true);

    final me = await ApiService.getMe();
    if (me['ok'] == true) {
      setState(() {
        profile = me['data'];
        loading = false;
      });
      return;
    }

    final dummy = Storage.getUser();
    if (dummy != null) {
      setState(() {
        profile = dummy;
        loading = false;
      });
      return;
    }

    setState(() {
      profile = null;
      loading = false;
    });
  }

  String _initials(String name) {
    if (name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
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
    return Scaffold(
      backgroundColor: softBlue,

      // =========================================================
      // ✅ Tambahkan AppBar dengan tombol back (Pilihan C)
      // =========================================================
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // =========================================================
      body: SafeArea(
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  // Header curved
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [pastelBlue, deepIndigo],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: profile == null
                          ? Text(
                              'Profile',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 36,
                                    backgroundColor: deepIndigo,
                                    child: Text(
                                      _initials(profile!['name'] ?? 'User'),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  profile!['name'] ?? '-',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  profile!['email'] ?? '-',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                    ),
                  ),

                  SizedBox(height: 18),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Role',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  profile!['role'] ?? '-',
                                  style: TextStyle(fontSize: 16),
                                ),
                                Divider(height: 20),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.person),
                                  title: Text('My Profile'),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () {},
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: Icon(Icons.logout),
                                  title: Text('Logout'),
                                  onTap: _logout,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 18),

                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 12,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.edit, color: deepIndigo),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text('Edit profile (coming soon)'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Icon(Icons.settings, color: deepIndigo),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text('Settings (coming soon)'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
