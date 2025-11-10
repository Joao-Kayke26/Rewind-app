import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://reqres.in/api/', // base fake — pode trocar depois
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // ============================
  // LOGIN (Fake)
  // ============================
  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // simula sucesso se email e senha batem com um padrão fake
      if (response.statusCode == 200 || email == 'teste@teste.com' && password == '123456') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Erro no login: $e');
      return false;
    }
  }

  // ============================
  // REGISTRO (Fake)
  // ============================
  Future<bool> register(String email, String password) async {
    try {
      final response = await _dio.post(
        'register',
        data: {
          'email': email,
          'password': password,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erro no registro: $e');
      return false;
    }
  }

  // ============================
  // ESQUECEU A SENHA (Fake)
  // ============================
  Future<bool> forgotPassword(String email) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // simula sucesso se email contém '@'
      return email.contains('@');
    } catch (e) {
      print('Erro no esqueci a senha: $e');
      return false;
    }
  }

  // ============================
  // VERIFICAÇÃO DE CÓDIGO (Fake)
  // ============================
  Future<bool> verifyCode(String code) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      // simula código correto = 123456
      return code == '123456';
    } catch (e) {
      print('Erro na verificação do código: $e');
      return false;
    }
  }

  // ============================
  // REDEFINIÇÃO DE SENHA (Fake)
  // ============================
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return newPassword.length >= 6;
    } catch (e) {
      print('Erro na redefinição de senha: $e');
      return false;
    }
  }

  // ============================
  // FILMES (Fake)
  // ============================
  Future<List<Movie>> fetchMovies() async {
    try {
      await Future.delayed(const Duration(seconds: 2));

      // Fake JSON simulando resposta de API
      final List<Map<String, dynamic>> fakeData = [
        {
          "id": 1,
          "title": "Duna 2",
          "image": "https://image.tmdb.org/t/p/w500/8bcoRX3hQRHufLPSDREdvr3YMXx.jpg",
          "category": "Lançamentos"
        },
        {
          "id": 2,
          "title": "Oppenheimer",
          "image": "https://image.tmdb.org/t/p/w500/bAFmcrpTfvfKozl0RfQ8vxO5TgO.jpg",
          "category": "Lançamentos"
        },
        {
          "id": 3,
          "title": "Avatar 2",
          "image": "https://image.tmdb.org/t/p/w500/t6HIqrRAclMCA60NsSmeqe9RmNV.jpg",
          "category": "Populares"
        },
        {
          "id": 4,
          "title": "Interestelar",
          "image": "https://image.tmdb.org/t/p/w500/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg",
          "category": "Populares"
        },
        {
          "id": 5,
          "title": "Matrix",
          "image": "https://image.tmdb.org/t/p/w500/aOi18t8xgI6FHDbj3kH2B8t6grm.jpg",
          "category": "Clássicos"
        },
        {
          "id": 6,
          "title": "O Senhor dos Anéis",
          "image": "https://image.tmdb.org/t/p/w500/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg",
          "category": "Clássicos"
        },
        {
          "id": 7,
          "title": "Homem-Aranha: Sem Volta Para Casa",
          "image": "https://image.tmdb.org/t/p/w500/1g0dhYtq4irTY1GPXvft6k4YLjm.jpg",
          "category": "Populares"
        },
        {
          "id": 8,
          "title": "Batman",
          "image": "https://image.tmdb.org/t/p/w500/74xTEgt7R36Fpooo50r9T25onhq.jpg",
          "category": "Ação"
        },
        {
          "id": 9,
          "title": "Vingadores: Ultimato",
          "image": "https://image.tmdb.org/t/p/w500/ulzhLuWrPK07P1YkdWQLZnQh1JL.jpg",
          "category": "Ação"
        },
      ];

      return fakeData.map((json) => Movie.fromJson(json)).toList();
    } catch (e) {
      print('Erro ao buscar filmes: $e');
      return [];
    }
  }
}
