import 'package:http/http.dart' as http;

// get is a reserved word
// ignore: constant_identifier_names
enum RequestType { GET, POST, PUT, DELETE }

abstract class HttpCaller {
  Future<http.Response> call(
    final RequestType type,
    final Uri uri, {
    final Map<String, String>? headers,
    final String? body,
  });
}
