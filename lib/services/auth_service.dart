import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';

class AuthService {
  final String baseUrl = 'http://localhost:8080';

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'] as String?;
      if (token != null) {
        await TokenStorage.saveToken(token);
        return true;
      }
      return false;
    } else {
      // aqui você pode tratar códigos 401, 400, etc.
      return false;
    }
  }

  Future<void> logout() async {
    await TokenStorage.removeToken();
  }

  Future<bool> isLogged() async {
    final token = await TokenStorage.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> register(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }
}
