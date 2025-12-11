import 'package:flutter/material.dart';
import '../../utils/storage.dart';

class EditProfileAdminPoli extends StatefulWidget {
  @override
  State<EditProfileAdminPoli> createState() => _EditProfileAdminPoliState();
}

class _EditProfileAdminPoliState extends State<EditProfileAdminPoli> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nama;
  late TextEditingController email;
  late TextEditingController poli;
  late TextEditingController jumlahDokter;
  late TextEditingController jumlahSuster;

  @override
  void initState() {
    super.initState();
    final user = Storage.getUser();

    nama = TextEditingController(text: user?["name"] ?? "");
    email = TextEditingController(text: user?["email"] ?? "");
    poli = TextEditingController(text: user?["poli"] ?? "");

    jumlahDokter = TextEditingController(
      text: user?["jumlah_dokter"]?.toString() ?? "",
    );

    jumlahSuster = TextEditingController(
      text: user?["jumlah_suster"]?.toString() ?? "",
    );
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = {
      "role": "admin_poli",
      "name": nama.text,
      "email": email.text,
      "poli": poli.text,
      "jumlah_dokter": jumlahDokter.text,
      "jumlah_suster": jumlahSuster.text,
    };

    await Storage.saveUser(updated);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil Admin Poli"),
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
              _field("Nama Poli", poli),
              _field("Jumlah Dokter", jumlahDokter),
              _field("Jumlah Suster", jumlahSuster),

              SizedBox(height: 16),

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
