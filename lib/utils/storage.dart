import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ================= TOKEN =================
  static Future<void> saveToken(String token) async {
    await _prefs.setString("token", token);
  }

  static String? getToken() {
    return _prefs.getString("token");
  }

  // ================= USER =================
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs.setString("user", jsonEncode(user));
  }

  static Map<String, dynamic>? getUser() {
    final raw = _prefs.getString("user");
    if (raw == null) return null;
    return jsonDecode(raw);
  }

  static Future<void> clear() async {
    await _prefs.clear();
  }
}
