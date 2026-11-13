abstract final class Constants {
  static const String appName = 'Scholaris';

  /// API base URL.
  ///
  /// Override at build time with `--dart-define=API_BASE_URL=...` or load it
  /// from a `.env` file with `--dart-define-from-file=.env` (Flutter 3.13+).
  ///
  /// The default is the hosted Scholaris API. Set `API_BASE_URL` in `.env`
  /// (see `.env.example`) to use a different backend for development.
  static const String defaultApiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://scholarisapi.onrender.com',
  );

  static const String secureStorageTokenKey = 'scholaris_token';
  static const String secureStorageUserKey = 'scholaris_user';
}
