// lib/screens/edit_profile_screen.dart
import 'package:flutter/material.dart';
import '../utils/storage.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  EditProfileScreen({required this.user});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController emailCtrl;

  final Color deepIndigo = Color(0xFF4741A6);

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: widget.user['name']);
    emailCtrl = TextEditingController(text: widget.user['email']);
  }

  void save() async {
    final updated = {
      'name': nameCtrl.text.trim(),
      'email': emailCtrl.text.trim(),
      'role': widget.user['role'],
      'password': widget.user['password'],
    };

    await Storage.saveUser(updated);

    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profil"), backgroundColor: deepIndigo),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: "Nama",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 14),
            TextField(
              controller: emailCtrl,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              style: ElevatedButton.styleFrom(
                backgroundColor: deepIndigo,
                foregroundColor: Colors.white,
              ),
              child: Text("Simpan Data"),
            ),
          ],
        ),
      ),
    );
  }
}
