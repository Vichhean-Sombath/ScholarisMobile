import '../../core/errors.dart';
import '../../core/result.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_api.dart';
import '../services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthApi authApi,
    required SecureStorageService secureStorage,
  }) : _authApi = authApi,
       _secureStorage = secureStorage;

  final AuthApi _authApi;
  final SecureStorageService _secureStorage;

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final response = await _authApi.login(email, password);
      await _secureStorage.saveToken(response.token);
      await _secureStorage.saveUser(response.user);
      return Result.success(response.user);
    } on AppException catch (e) {
      return Result.failure(e);
    } catch (e) {
      return Result.failure(AppException('Login failed: $e'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // Ignore logout API errors and always clear local storage.
    } finally {
      await _secureStorage.clearAll();
    }
    return const Result.success(null);
  }

  @override
  Future<bool> isAuthenticated() async {
    final token = await _secureStorage.getToken();
    return token != null && token.isNotEmpty;
  }
}
