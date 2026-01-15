import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../utils/storage.dart';
import '../../services/api_service.dart';

class EditProfileDosen extends StatefulWidget {
  @override
  State<EditProfileDosen> createState() => _EditProfileDosenState();
}

class _EditProfileDosenState extends State<EditProfileDosen> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> user = {};
  bool loading = true;

  late TextEditingController nama;
  late TextEditingController nip;
  late TextEditingController jabatan;
  late TextEditingController keahlian;
  late TextEditingController email;

  String? filePath;

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

    final dsn = user["dosen"] ?? {};

    nama = TextEditingController(text: user["name"] ?? "");
    nip = TextEditingController(text: dsn["nip"] ?? "");
    jabatan = TextEditingController(text: dsn["jabatan"] ?? "");
    keahlian = TextEditingController(text: dsn["keahlian"] ?? "");
    email = TextEditingController(text: dsn["email"] ?? "");

    filePath = dsn["file_bimbingan"];

    setState(() => loading = false);
  }

  /// ===============================
  /// PICK FILE EXCEL
  /// ===============================
  Future<void> pickExcel() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx", "xls"],
    );

    if (result != null) {
      setState(() {
        filePath = result.files.single.path;
      });
    }
  }

  /// ===============================
  /// SAVE DATA (TIDAK HAPUS DATA LAMA)
  /// ===============================
  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await ApiService.updateProfile({
      "role": "dosen",
      "name": nama.text,
      "nip": nip.text,
      "jabatan": jabatan.text,
      "keahlian": keahlian.text,
      "email": email.text,
      "file_bimbingan": filePath,
    });

    if (success) {
      await ApiService.getMe(); // refresh user
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal Update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil Dosen"),
        backgroundColor: const Color(0xFF133E87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Nama", nama),
              _field("NIP / NIDN", nip),
              _field("Jabatan", jabatan),
              _field("Keahlian", keahlian),
              _field("Email", email),

              const SizedBox(height: 14),

              const Text(
                "Upload Daftar Mahasiswa Bimbingan (Excel)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              ElevatedButton(
                onPressed: pickExcel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF133E87),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Upload File Excel"),
              ),

              if (filePath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "File: $filePath",
                    style: const TextStyle(fontSize: 12),
                  ),
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
  Widget _field(String title, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
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
