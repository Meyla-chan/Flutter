import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../../services/api_service.dart';

class EditProfileAdminProdi extends StatefulWidget {
  @override
  State<EditProfileAdminProdi> createState() => _EditProfileAdminProdiState();
}

class _EditProfileAdminProdiState extends State<EditProfileAdminProdi> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> user = {};
  bool loading = true;

  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController prodi;
  late TextEditingController fakultas;
  late TextEditingController jumlahMahasiswa;
  late TextEditingController jumlahDosen;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  /// ===============================
  /// LOAD USER (AMAN & ASYNC)
  /// ===============================
  void _loadUser() async {
    final u = await Storage.getUser();

    if (!mounted) return;

    user = u ?? {};

    nama = TextEditingController(text: user["name"] ?? "");
    email = TextEditingController(text: user["email"] ?? "");
    prodi = TextEditingController(text: user["prodi"] ?? "");
    fakultas = TextEditingController(text: user["fakultas"] ?? "");
    jumlahMahasiswa = TextEditingController(
      text: user["jumlah_mahasiswa"]?.toString() ?? "",
    );
    jumlahDosen = TextEditingController(
      text: user["jumlah_dosen"]?.toString() ?? "",
    );

    setState(() => loading = false);
  }

  /// ===============================
  /// SAVE (PERTAHANKAN DATA LAMA)
  /// ===============================
  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Storage.getUser();
    final id = user!["id"];

    final success = await ApiService.updateUser(id, {
      "role": "admin_prodi",
      "name": nama.text,
      "email": email.text,
      "prodi": prodi.text,
      "fakultas": fakultas.text,
      "jumlah_mahasiswa": jumlahMahasiswa.text,
      "jumlah_dosen": jumlahDosen.text,
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
        title: const Text("Edit Profil Admin Prodi"),
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
              _field("Program Studi", prodi),
              _field("Fakultas", fakultas),
              _field(
                "Jumlah Mahasiswa",
                jumlahMahasiswa,
                keyboard: TextInputType.number,
              ),
              _field(
                "Jumlah Dosen",
                jumlahDosen,
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
  /// FORM FIELD
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
