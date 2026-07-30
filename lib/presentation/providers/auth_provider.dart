import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'dependency_providers.dart';

sealed class AuthState {
  const AuthState();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User? user;
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authRepository) : super(const AuthLoading()) {
    checkAuth();
  }

  final AuthRepository _authRepository;

  Future<void> checkAuth() async {
    final isAuthenticated = await _authRepository.isAuthenticated();
    if (isAuthenticated) {
      state = const AuthAuthenticated(null);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<String?> login(String email, String password) async {
    state = const AuthLoading();
    final result = await _authRepository.login(email, password);
    return result.when(
      success: (user) {
        state = AuthAuthenticated(user);
        return null;
      },
      failure: (error) {
        state = const AuthUnauthenticated();
        return error.message;
      },
    );
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthUnauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
