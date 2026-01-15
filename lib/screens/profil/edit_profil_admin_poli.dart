import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../../services/api_service.dart';

class EditProfileAdminPoli extends StatefulWidget {
  @override
  State<EditProfileAdminPoli> createState() => _EditProfileAdminPoliState();
}

class _EditProfileAdminPoliState extends State<EditProfileAdminPoli> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> user = {};
  bool loading = true;

  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController poli;
  late TextEditingController jumlahDokter;
  late TextEditingController jumlahSuster;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// ===============================
  /// LOAD USER (ASYNC & AMAN)
  /// ===============================
  void _loadUser() async {
    final u = await Storage.getUser();

    if (!mounted) return;

    user = u ?? {};

    nama = TextEditingController(text: user["name"] ?? "");
    email = TextEditingController(text: user["email"] ?? "");
    poli = TextEditingController(text: user["poli"] ?? "");
    jumlahDokter = TextEditingController(
      text: user["jumlah_dokter"]?.toString() ?? "",
    );
    jumlahSuster = TextEditingController(
      text: user["jumlah_suster"]?.toString() ?? "",
    );

    setState(() => loading = false);
  }

  /// ===============================
  /// SAVE (DATA LAMA TIDAK HILANG)
  /// ===============================
  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Storage.getUser();
    final id = user!["id"];

    final success = await ApiService.updateUser(id, {
      "name": nama.text,
      "email": email.text,
      "poli": poli.text,
      "jumlah_dokter": jumlahDokter.text,
      "jumlah_suster": jumlahSuster.text,
    });

    if (success) {
      await ApiService.getMe(); // refresh user
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil Admin Poli"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Nama", nama),
              _field("Email", email),
              _field("Nama Poli", poli),
              _field(
                "Jumlah Dokter",
                jumlahDokter,
                keyboard: TextInputType.number,
              ),
              _field(
                "Jumlah Suster",
                jumlahSuster,
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF133E87),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// FIELD WIDGET
  /// ===============================
  Widget _field(
    String title,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v == null || v.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}
