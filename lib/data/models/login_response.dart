import '../../domain/models/user.dart';

class LoginResponse {
  const LoginResponse({required this.token, required this.user});

  final String token;
  final User user;

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String? ?? '',
      user: User.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
    );
  }
}
