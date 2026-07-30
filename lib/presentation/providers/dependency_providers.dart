import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/student_repository_impl.dart';
import '../../data/services/api_client.dart';
import '../../data/services/auth_api.dart';
import '../../data/services/secure_storage_service.dart';
import '../../data/services/student_api.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/student_repository.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(FlutterSecureStorage());
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(secureStorage: ref.watch(secureStorageProvider));
});

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.watch(apiClientProvider).dio);
});

final studentApiProvider = Provider<StudentApi>((ref) {
  return StudentApi(ref.watch(apiClientProvider).dio);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    authApi: ref.watch(authApiProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

final studentRepositoryProvider = Provider<StudentRepository>((ref) {
  return StudentRepositoryImpl(studentApi: ref.watch(studentApiProvider));
});
