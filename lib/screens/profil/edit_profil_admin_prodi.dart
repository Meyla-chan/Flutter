import 'package:flutter/material.dart';
import '../../utils/storage.dart';

class EditProfileAdminProdi extends StatefulWidget {
  @override
  State<EditProfileAdminProdi> createState() => _EditProfileAdminProdiState();
}

class _EditProfileAdminProdiState extends State<EditProfileAdminProdi> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController prodi;
  late TextEditingController fakultas;
  late TextEditingController jumlahMahasiswa;
  late TextEditingController jumlahDosen;

  @override
  void initState() {
    super.initState();
    final user = Storage.getUser();

    nama = TextEditingController(text: user?["name"] ?? "");
    email = TextEditingController(text: user?["email"] ?? "");
    prodi = TextEditingController(text: user?["prodi"] ?? "");
    fakultas = TextEditingController(text: user?["fakultas"] ?? "");

    jumlahMahasiswa = TextEditingController(
      text: user?["jumlah_mahasiswa"]?.toString() ?? "",
    );

    jumlahDosen = TextEditingController(
      text: user?["jumlah_dosen"]?.toString() ?? "",
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = {
      "role": "admin_prodi",
      "name": nama.text,
      "email": email.text,
      "prodi": prodi.text,
      "fakultas": fakultas.text,
      "jumlah_mahasiswa": jumlahMahasiswa.text,
      "jumlah_dosen": jumlahDosen.text,
    };

    await Storage.saveUser(updated);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil Admin Prodi"),
        backgroundColor: Color(0xFF133E87),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Nama", nama),
              _field("Email", email),
              _field("Program Studi", prodi),
              _field("Fakultas", fakultas),
              _field("Jumlah Mahasiswa", jumlahMahasiswa),
              _field("Jumlah Dosen", jumlahDosen),

              SizedBox(height: 18),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF133E87),
                ),
                child: Text(
                  "Simpan Perubahan",
                  style: TextStyle(color: Colors.white),
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
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(),
        ),
        validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
      ),
    );
  }
}
