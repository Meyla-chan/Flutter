import 'package:flutter/material.dart';
import '../../utils/storage.dart';
import '../../services/api_service.dart';

class EditProfileMahasiswa extends StatefulWidget {
  @override
  State<EditProfileMahasiswa> createState() => _EditProfileMahasiswaState();
}

class _EditProfileMahasiswaState extends State<EditProfileMahasiswa> {
  bool loading = true;

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
    _loadUser();
  }

  void _loadUser() async {
    final u = await Storage.getUser();
    if (!mounted) return;

    user = u ?? {};

    // Ambil data nested
    final mhs = user["mahasiswa"] ?? {};

    nama = TextEditingController(text: user["name"] ?? "");

    // Ambil dari variabel 'mhs', bukan 'user' langsung
    nim = TextEditingController(text: mhs["nim"] ?? "");
    prodi = TextEditingController(
      text: mhs["program_studi"] ?? "",
    ); // Pastikan key sama dengan API (program_studi / prodi)
    fakultas = TextEditingController(text: mhs["fakultas"] ?? "");
    angkatan = TextEditingController(text: mhs["angkatan"] ?? "");
    kelas = TextEditingController(text: mhs["kelas"] ?? "");
    dosenPa = TextEditingController(text: mhs["dosen_pa"] ?? "");
    status = TextEditingController(text: mhs["status"] ?? "");

    setState(() {
      loading = false;
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;

    // Panggil fungsi updateProfile yang baru (tanpa ID)
    final success = await ApiService.updateProfile({
      "name": nama.text, // Backend butuh ini
      "nim": nim.text,
      "program_studi": prodi
          .text, // Pastikan key kiriman sesuai request Laravel ($request->program_studi)
      "fakultas": fakultas.text,
      "angkatan": angkatan.text,
      "kelas": kelas.text,
      "dosen_pa": dosenPa.text,
      "status": status.text,
    });

    if (success) {
      await ApiService.getMe(); // Refresh data user lokal
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
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
