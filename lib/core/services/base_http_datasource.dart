import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/constants/api_constants.dart';
import '../../shared/models/api_response.dart';
import '../clients/http_client.dart';
import '../clients/http_client_impl.dart';
import 'storage/secure_storage_service.dart';
import 'storage/secure_storage_service_impl.dart';

abstract class BaseHttpDataSource {
  BaseHttpDataSource({
    final String? baseUrl,
    final HttpCaller? httpClient,
    final SecureStorageService? secureStorageService,
  }) : _baseUrl = baseUrl ?? ApiConstants.baseUrl,
       _httpClient = httpClient ?? HttpCallerImpl(),
       _secureStorageService =
           secureStorageService ?? SecureStorageServiceImpl();

  final HttpCaller _httpClient;
  final String _baseUrl;
  final SecureStorageService _secureStorageService;

  String get noticesPath => '/notices';

  String get apartmentsPath => '/apartments';

  String get condominiaPath => '/condominia';

  String get reservationsPath => '/reservations';

  String get facilitiesPath => '/facilities';

  Map<String, String> get _jsonContentHeader => {
    'Content-Type': 'application/json',
  };

  Map<String, String> get _camelCaseHeader => {'Key-Inflection': 'camel'};

  Future<ApiResponse<T>> makeRequest<T>(
    final RequestType type,
    final String path, {
    final Map<String, dynamic>? jsonBody,
    final Map<String, String>? headers,
    final Map<String, String>? queryParams,
    final T Function(Object)? fromJson,
    final bool includeAuth = true,
  }) async {
    try {
      final Uri uri = buildUri(path, queryParams: queryParams);
      final String? body = jsonBody != null ? jsonEncode(jsonBody) : null;

      final http.Response response = await _httpClient.call(
        type,
        uri,
        headers: {...?headers, ..._jsonContentHeader, ..._camelCaseHeader},
        body: body,
      );

      return _handleResponse<T>(response, fromJson);
    } on Exception catch (e) {
      return ApiResponse<T>(
        success: false,
        message: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Uri buildUri(final String path, {final Map<String, String>? queryParams}) {
    final Uri uri = Uri.parse('$_baseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Future<Map<String, String>> buildAuthHeaderFromStorage() async {
    final String? token = await _secureStorageService.getAccessToken();
    if (token != null) {
      return buildAuthHeader(token);
    }
    return {};
  }

  Map<String, String> buildAuthHeader(final String? token) => {
    'Authorization': 'Bearer $token',
  };

  Future<void> persistAuthHeader(final String token) async {
    await _secureStorageService.saveAccessToken(token);
  }

  Future<void> clearAccessToken() async {
    await _secureStorageService.clearAccessToken();
  }

  ApiResponse<T> _handleResponse<T>(
    final http.Response response,
    final T Function(Object)? fromJson,
  ) {
    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      try {
        final dynamic decodedJson = jsonDecode(response.body);

        T? data;
        if (fromJson != null) {
          data = fromJson(decodedJson);
        } else {
          data = decodedJson as T?;
        }

        return ApiResponse<T>(
          success: true,
          data: data,
          statusCode: response.statusCode,
          headers: response.headers,
        );
      } on Exception catch (e) {
        return ApiResponse<T>(
          success: false,
          message: 'Failed to parse response: $e',
          statusCode: response.statusCode,
        );
      }
    } else {
      return ApiResponse<T>(
        success: false,
        message: _getErrorMessage(response),
        statusCode: response.statusCode,
      );
    }
  }

  String _getErrorMessage(final http.Response response) {
    switch (response.statusCode) {
      case 404:
        return 'Not found: ${response.statusCode}';
      case 504:
        return 'Timeout: ${response.statusCode}';
      default:
        return 'HTTP Error: ${response.statusCode} - ${response.body}';
    }
  }
}
