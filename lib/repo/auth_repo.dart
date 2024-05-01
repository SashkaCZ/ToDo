import 'package:dio/dio.dart';

class AuthRepository {
  late Dio _dio;

  AuthRepository() {
    _dio = Dio();
  }

  Future<void> login(String email, String password) async {
    try {
      // Отправьте запрос на вход через API
      Response response = await _dio.post(
        'https://test-mobile.estesis.tech/api/v1/login',
        data: {
          'username': email,
          'password': password,
        },
      );
    } catch (error) {
      print('Ошибка при входе: $error');
      rethrow;
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      Response response = await _dio.post(
        'https://test-mobile.estesis.tech/api/v1/register',
        data: {
          'name': username,
          'email': email,
          'password': password,
        },
      );
    } catch (error) {
      print('Ошибка при регистрации: $error');
      throw error;
    }
  }
}
