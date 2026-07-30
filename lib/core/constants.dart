abstract final class Constants {
  static const String appName = 'Scholaris';

  /// API base URL.
  ///
  /// Override at build time with `--dart-define=API_BASE_URL=...` or load it
  /// from a `.env` file with `--dart-define-from-file=.env` (Flutter 3.13+).
  ///
  /// The default is `http://10.0.2.2:3000/` for Android emulator local
  /// development. For production or a real device, set `API_BASE_URL` in
  /// `.env` (see `.env.example`).
  static const String defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:3000/',
  );

  static const String secureStorageTokenKey = 'scholaris_token';
  static const String secureStorageUserKey = 'scholaris_user';
}
