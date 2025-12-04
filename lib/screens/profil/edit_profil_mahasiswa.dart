import 'package:flutter/material.dart';
import '../../utils/storage.dart';

class EditProfileMahasiswa extends StatefulWidget {
  @override
  State<EditProfileMahasiswa> createState() => _EditProfileMahasiswaState();
}

class _EditProfileMahasiswaState extends State<EditProfileMahasiswa> {
  final _formKey = GlobalKey<FormState>();

  late Map<String, dynamic> user;

  late TextEditingController nama;
  late TextEditingController nim;
  late TextEditingController prodi;
  late TextEditingController fakultas;
  late TextEditingController angkatan;
  late TextEditingController kelas;
  late TextEditingController dosenPa;
  late TextEditingController status;

  @override
  void initState() {
    super.initState();

    // AMAN DARI NULL
    user = Storage.getUser() ?? {};

    nama = TextEditingController(text: user["name"] ?? "");
    nim = TextEditingController(text: user["nim"] ?? "");
    prodi = TextEditingController(text: user["prodi"] ?? "");
    fakultas = TextEditingController(text: user["fakultas"] ?? "");
    angkatan = TextEditingController(text: user["angkatan"] ?? "");
    kelas = TextEditingController(text: user["kelas"] ?? "");
    dosenPa = TextEditingController(text: user["dosen_pa"] ?? "");
    status = TextEditingController(text: user["status"] ?? "");
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = {
      "role": "mahasiswa",
      "name": nama.text,
      "nim": nim.text,
      "prodi": prodi.text,
      "fakultas": fakultas.text,
      "angkatan": angkatan.text,
      "kelas": kelas.text,
      "dosen_pa": dosenPa.text,
      "status": status.text,
    };

    await Storage.saveUser(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE8F1FA),
      appBar: AppBar(
        title: Text("Edit Profil Mahasiswa"),
        backgroundColor: Color(0xFF133E87),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Nama", nama),
              _field("NIM", nim),
              _field("Program Studi", prodi),
              _field("Fakultas", fakultas),
              _field("Angkatan", angkatan),
              _field("Kelas", kelas),
              _field("Dosen PA", dosenPa),
              _field("Status", status),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF133E87),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Simpan Perubahan",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(String title, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: title,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}
