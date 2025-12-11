import 'dart:io';

class ApiConstants {
  static final String baseUrl = _defaultApiUrl;

  static final _defaultApiUrl = Platform.isAndroid
      ? 'http://10.0.0.156:3000'
      : 'http://localhost:8080';

  static const timeout = Duration(seconds: 10);
}
