import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class ApiService {
  static const baseUrl = "https://micro.deva-syaiful.my.id/api";

  // ================= HEADER =================
  static Map<String, String> _headers({bool auth = false}) {
    final token = Storage.getToken();
    return {
      "Content-Type": "application/json",
      "Accept": "application/json", // Wajib untuk Laravel
      if (auth && token != null) "Authorization": "Bearer $token",
    };
  }

  // ================= REGISTER =================
  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/register"),
        headers: _headers(),
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
        }),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200 || res.statusCode == 201) {
        return {"ok": true, "data": body};
      }

      return {"ok": false, "message": body["message"] ?? "Registrasi gagal"};
    } catch (e) {
      return {"ok": false, "message": "Koneksi Error: $e"};
    }
  }

  // ================= LOGIN =================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      // 1. Request Login
      final res = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: _headers(),
        body: jsonEncode({"email": email, "password": password}),
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // 2. Ambil Token (Sesuaikan dengan struktur API Laravelmu)
        // Cek path: body['data']['access_token']
        String? token = body['data']?['access_token'] ?? body['access_token'];

        if (token != null) {
          // 3. Simpan Token Dulu
          await Storage.saveToken(token);

          // 4. STRATEGI JEMPUT BOLA:
          // Karena login tidak bawa data user, kita panggil /me sekarang juga
          final userRes = await getMe(); // Panggil fungsi getMe di bawah

          if (userRes['ok'] == true) {
            return {"ok": true}; // Sukses Login + Dapat User
          } else {
            return {"ok": false, "message": "Gagal mengambil profil user"};
          }
        }
      }

      return {"ok": false, "message": body["message"] ?? "Login Gagal"};
    } catch (e) {
      print("Error Login: $e");
      return {"ok": false, "message": "Terjadi kesalahan koneksi"};
    }
  }

  // ================= GET ME =================
  static Future<Map<String, dynamic>> getMe() async {
    try {
      final res = await http.get(
        Uri.parse("$baseUrl/me"),
        headers: _headers(auth: true), // Pakai token yang baru disimpan
      );

      final body = jsonDecode(res.body);

      if (res.statusCode == 200) {
        // Ambil data user (biasanya ada di dalam key 'data' atau langsung di root)
        final userData = body['data'] ?? body;

        // Simpan ke HP
        await Storage.saveUser(userData);

        return {"ok": true, "data": userData};
      }

      return {"ok": false};
    } catch (e) {
      return {"ok": false};
    }
  }

  // ================= UPDATE USER =================
  static Future<bool> updateUser(int id, Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/admin/users/$id"),
        headers: _headers(auth: true),
        body: jsonEncode(data),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/profile/update"), // <--- GANTI KE INI
        headers: _headers(auth: true),
        body: jsonEncode(data),
      );
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ================= LOGOUT =================
  static Future<void> logout() async {
    try {
      await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: _headers(auth: true),
      );
    } catch (e) {
      // Ignore error
    } finally {
      await Storage.clear();
    }
  }
}
