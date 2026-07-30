import 'package:dio/dio.dart';

import '../models/login_request.dart';
import '../models/login_response.dart';
import 'api_client.dart';

class AuthApi {
  AuthApi(this._dio);

  final Dio _dio;

  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/user/login',
        data: LoginRequest(email: email, password: password).toJson(),
      );
      return LoginResponse.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/user/logout');
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}
