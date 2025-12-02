import 'dart:io';

class ApiConstants {
  static final String baseUrl = _defaultApiUrl;

  static final _defaultApiUrl =
      Platform.isAndroid ? 'http://10.0.0.87:8080' : 'http://localhost:8080';

  static const timeout = Duration(seconds: 10);
}
