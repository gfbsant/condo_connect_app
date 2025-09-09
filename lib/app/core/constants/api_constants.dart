import 'dart:io';

class ApiConstants {
  static final String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultApiUrl,
  );

  static final String _defaultApiUrl =
      Platform.isAndroid ? 'http://10.0.0.158:8080' : 'http://localhost:8080';

  static const Duration timeout = Duration(seconds: 10);
}
