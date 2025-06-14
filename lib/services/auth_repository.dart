import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mobile/api/api.dart';

class AuthRepository {
  Future<void> signup(String userName, String email, String password) async {
    final response = await http.post(
      signupUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": userName,
        "email": email,
        "password": password,
      }),
    );
    if (response.statusCode != 201 && response.statusCode != 200) {
      try {
        final data = jsonDecode(response.body);
        print('Signup data: $data');
        throw Exception(data['error'] ?? 'Signup failed');
      } catch (_) {
        throw Exception(response.body);
      }
    }
  }

  Future<Map> login(String email, String password) async {
    final response = await http.post(
      loginUrl,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        "uid": data['customer']['id'],
        "token": data['token'],
        "email": data['customer']['email'],
        "userName": data['customer']['username']
      };
    } else {
      try {
        final data = jsonDecode(response.body);
        throw Exception(data['error'] ?? 'Login failed');
      } catch (_) {
        throw Exception(response.body);
      }
    }
  }
}
