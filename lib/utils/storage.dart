import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static SharedPreferences? _prefs;
  static const _KEY_TOKEN = 'jwt_token';
  static const _KEY_USER = 'dummy_user';

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _prefs!.setString(_KEY_TOKEN, token);
  }

  static String? getToken() {
    return _prefs?.getString(_KEY_TOKEN);
  }

  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _prefs!.setString(_KEY_USER, jsonEncode(user));
  }

  static Map<String, dynamic>? getUser() {
    final data = _prefs?.getString(_KEY_USER);
    if (data == null) return null;
    return jsonDecode(data);
  }

  static Future<void> clear() async {
    await _prefs!.remove(_KEY_TOKEN);
    await _prefs!.remove(_KEY_USER);
  }
}
