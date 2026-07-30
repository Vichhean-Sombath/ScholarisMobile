import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/constants.dart';
import '../../domain/models/user.dart';

class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> saveToken(String token) async {
    await _storage.write(key: Constants.secureStorageTokenKey, value: token);
  }

  Future<String?> getToken() async {
    return _storage.read(key: Constants.secureStorageTokenKey);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: Constants.secureStorageTokenKey);
  }

  Future<void> saveUser(User user) async {
    await _storage.write(
      key: Constants.secureStorageUserKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<User?> getUser() async {
    final json = await _storage.read(key: Constants.secureStorageUserKey);
    if (json == null || json.isEmpty) return null;
    try {
      return User.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> clearUser() async {
    await _storage.delete(key: Constants.secureStorageUserKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
