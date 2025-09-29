import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../interfaces/http_client_interface.dart';

class HttpClientImpl implements HttpClientInterface {
  HttpClientImpl({this.timeoutSeconds = 10});

  final int timeoutSeconds;

  @override
  Future<http.Response> call(
    final RequestType type,
    final Uri uri, {
    Map<String, String>? headers,
    final String? body,
  }) {
    headers = headers ?? {};
    if (body != null && !headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json; charset=utf-8';
    }

    if (kIsWeb) {
      return _callWeb(type, uri, headers: headers, body: body);
    } else {
      return _callNative(type, uri, headers: headers, body: body);
    }
  }

  Future<http.Response> _callWeb(
    final RequestType type,
    final Uri uri, {
    final Map<String, String>? headers,
    final String? body,
  }) {
    switch (type) {
      case RequestType.GET:
        return http.get(uri, headers: headers);
      case RequestType.POST:
        return http.post(uri, headers: headers, body: body);
      case RequestType.PUT:
        return http.put(uri, headers: headers, body: body);
      case RequestType.DELETE:
        return http.delete(uri, headers: headers);
    }
  }

  Future<http.Response> _callNative(
    final RequestType type,
    final Uri uri, {
    final Map<String, String>? headers,
    final String? body,
  }) async {
    final bool withSSL = uri.toString().startsWith('https:');
    final HttpClient client = await _getClient(withSSL);

    try {
      HttpClientRequest request;
      switch (type) {
        case RequestType.GET:
          request = await client
              .getUrl(uri)
              .timeout(Duration(seconds: timeoutSeconds));
        case RequestType.POST:
          request = await client
              .postUrl(uri)
              .timeout(Duration(seconds: timeoutSeconds));
        case RequestType.PUT:
          request = await client
              .putUrl(uri)
              .timeout(Duration(seconds: timeoutSeconds));
        case RequestType.DELETE:
          request = await client
              .deleteUrl(uri)
              .timeout(Duration(seconds: timeoutSeconds));
      }

      headers?.forEach((final key, final value) {
        request.headers.set(key, value);
      });

      if (body != null) {
        request.write(body);
      }

      final HttpClientResponse response = await request.close();
      final String responseBody = await response
          .transform(
            response.headers.contentType?.charset == 'utf-8'
                ? const Utf8Decoder()
                : const Latin1Decoder(),
          )
          .join();

      return http.Response(
        responseBody,
        response.statusCode,
        headers: _convertHttpHeadersToMap(response.headers),
      );
    } finally {
      client.close();
    }
  }

  Future<HttpClient> _getClient(final bool withSSL) async {
    final client = HttpClient()
      ..badCertificateCallback =
          ((final cert, final hotst, final port) => true);
    return client;
  }

  Map<String, String> _convertHttpHeadersToMap(final HttpHeaders headers) {
    final Map<String, String> headerMap = {};
    headers.forEach((final name, final values) {
      headerMap[name] = values.join(',');
    });
    return headerMap;
  }
}
