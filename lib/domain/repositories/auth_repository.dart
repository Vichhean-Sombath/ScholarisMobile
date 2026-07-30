import '../../core/result.dart';
import '../models/user.dart';

abstract class AuthRepository {
  Future<Result<User>> login(String email, String password);
  Future<Result<void>> logout();
  Future<bool> isAuthenticated();
}
