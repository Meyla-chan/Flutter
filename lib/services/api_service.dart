import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final dummy = Storage.getUser();
    if (dummy != null &&
        dummy['email'] == email &&
        dummy['password'] == password) {
      return {'ok': true, 'token': 'dummy-token', 'user': dummy};
    }

    final url = Uri.parse('$baseUrl/login');
    try {
      final resp = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final body = resp.body.isNotEmpty ? jsonDecode(resp.body) : {};
      if (resp.statusCode == 200) {
        return {'ok': true, 'token': body['token'], 'user': body['user']};
      }
      return {'ok': false, 'message': 'Login failed'};
    } catch (e) {
      return {'ok': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> getMe() async {
    final user = Storage.getUser();
    if (user != null) return {'ok': true, 'data': user};
    return {'ok': false, 'message': 'No profile'};
  }
}
