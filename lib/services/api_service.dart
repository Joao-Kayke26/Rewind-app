// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/token_storage.dart';
import '../models/movie_model.dart';

class ApiService {
  final String baseUrl = "http://localhost:8080";

  Future<dynamic> getProtected(String path) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl$path');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // token inválido/expirado
      throw Exception('Não autorizado (401). Faça login novamente.');
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }

  // Exemplo POST protegido
  Future<dynamic> postProtected(String path, Map<String, dynamic> data) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl$path');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      throw Exception('Não autorizado (401).');
    } else {
      throw Exception('Erro ${response.statusCode}: ${response.body}');
    }
  }
  Future<bool> createMovie(Map<String, dynamic> movieData) async {
    final url = Uri.parse('$baseUrl/movies/');

    final token = await TokenStorage.getToken();

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode(movieData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        print("Erro API: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de conexão: $e");
      return false;
    }
  }

  Future<List<Movie>> fetchMovies() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/movies');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Movie.fromJson(json)).toList();
      } else {
        print('Erro ao buscar filmes: ${response.statusCode} - ${response.body}');
        return [];
      }
    } catch (e) {
      print('Erro de conexão ao buscar filmes: $e');
      return [];
    }
  }
  
  Future<bool> deleteMovie(String movieId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$baseUrl/movies/$movieId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Falha ao deletar filme: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Erro de conexão ao deletar: $e");
      return false;
    }
  }
}
