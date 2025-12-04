import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import 'package:file_picker/file_picker.dart';

class EditProfileDosen extends StatefulWidget {
  @override
  State<EditProfileDosen> createState() => _EditProfileDosenState();
}

class _EditProfileDosenState extends State<EditProfileDosen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nama;
  late TextEditingController nip;
  late TextEditingController jabatan;
  late TextEditingController keahlian;
  late TextEditingController email;

  String? filePath; // file excel untuk bimbingan

  @override
  void initState() {
    super.initState();
    final user = Storage.getUser();

    nama = TextEditingController(text: user?["name"] ?? "");
    nip = TextEditingController(text: user?["nip"] ?? "");
    jabatan = TextEditingController(text: user?["jabatan"] ?? "");
    keahlian = TextEditingController(text: user?["keahlian"] ?? "");
    email = TextEditingController(text: user?["email"] ?? "");

    filePath = user?["file_bimbingan"];
  }

  /// ============================================
  /// PICK FILE EXCEL
  /// ============================================
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

  /// ============================================
  /// SAVE
  /// ============================================
  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    final updated = {
      "role": "dosen",
      "name": nama.text,
      "nip": nip.text,
      "jabatan": jabatan.text,
      "keahlian": keahlian.text,
      "email": email.text,
      "file_bimbingan": filePath, // hanya file excel
    };

    await Storage.saveUser(updated);

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil Dosen"),
        backgroundColor: Color(0xFF133E87),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field("Nama", nama),
              _field("NIP / NIDN", nip),
              _field("Jabatan", jabatan),
              _field("Keahlian", keahlian),
              _field("Email", email),

              SizedBox(height: 12),
              Text("Upload Daftar Mahasiswa Bimbingan (Excel)"),
              SizedBox(height: 6),

              ElevatedButton(
                onPressed: pickExcel,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF133E87),
                  foregroundColor: Colors.white,
                ),
                child: Text("Upload File Excel"),
              ),

              if (filePath != null)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text("File: $filePath"),
                ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF133E87),
                  foregroundColor: Colors.white,
                ),
                child: Text("Simpan Perubahan"),
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
