import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../core/constants.dart';
import '../../core/errors.dart';
import 'auth_interceptor.dart';
import 'secure_storage_service.dart';

class ApiClient {
  ApiClient({Dio? dio, required SecureStorageService secureStorage})
    : _dio = dio ?? _createDio(secureStorage);

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _createDio(SecureStorageService secureStorage) {
    final baseUrl = Constants.defaultApiBaseUrl;
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(secureStorage));

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          logPrint: (object) => debugPrint(object.toString()),
        ),
      );
    }

    return dio;
  }
}

extension DioErrorX on DioException {
  AppException toAppException() {
    final message = _extractMessage();
    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final code = response?.statusCode;
        if (code == 401 || code == 403) {
          return const UnauthorizedException();
        }
        return ServerException(message ?? 'Request failed');
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
      default:
        return const NetworkException();
    }
  }

  String? _extractMessage() {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        final msg = data['message'];
        if (msg is String && msg.isNotEmpty) return msg;
      } else if (data is String && data.isNotEmpty) {
        final msg = data.split('"message":"').elementAtOrNull(1);
        if (msg != null) {
          return msg.split('"').firstOrNull;
        }
      }
    } catch (_) {}
    return response?.statusMessage ?? message;
  }
}
