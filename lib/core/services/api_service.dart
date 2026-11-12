import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Use 127.0.0.1 for Chrome / Web / Desktop
  // (Switch back to 10.0.2.2 if you test on the Android Emulator later)
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['access_token']);
        await prefs.setString('username', data['username']);
        await prefs.setInt('rating', data['rating'] ?? 1200);
        return {'success': true, 'data': data};
      } else {
        final err = jsonDecode(response.body);
        return {'success': false, 'message': err['detail'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server: $e'};
    }
  }

  static Future> signup(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true};
      } else {
        final err = jsonDecode(response.body);
        return {'success': false, 'message': err['detail'] ?? 'Signup failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Could not connect to server: $e'};
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}