import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../data/clients/http_client.dart';
import '../../data/interfaces/http_client_interface.dart';
import '../../data/models/api_response.dart';

abstract class BaseHttpService {
  BaseHttpService({
    required this.baseUrl,
    final HttpClientInterface? httpClient,
  }) : _httpClient = httpClient ?? HttpClientImpl();

  final HttpClientInterface _httpClient;
  final String baseUrl;

  HttpClientInterface get httpClient => _httpClient;

  Future<ApiResponse<T>> makeRequest<T>(
    final RequestType type,
    final String path, {
    final Map<String, dynamic>? jsonBody,
    final Map<String, String>? headers,
    final Map<String, String>? queryParams,
    final T Function(Object)? fromJson,
  }) async {
    try {
      final Uri uri = buildUri(path, queryParams: queryParams);
      final String? body = jsonBody != null ? jsonEncode(jsonBody) : null;

      final http.Response response = await _httpClient.call(
        type,
        uri,
        headers: headers,
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
    final Uri uri = Uri.parse('$baseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: queryParams);
    }
    return uri;
  }

  Map<String, String> buildAuthHeader(final String? token) =>
      {'Authorization': 'Bearer $token'};

  Map<String, String> get jsonContentHeader =>
      {'Content-Type': 'application/json'};

  ApiResponse<T> _handleResponse<T>(
    final http.Response response,
    final T Function(Object)? fromJson,
  ) {
    if (response.statusCode == 200) {
      try {
        final dynamic decodedJson = jsonDecode(response.body);

        if (decodedJson is Map<String, dynamic> &&
            decodedJson['success'] == false) {
          return ApiResponse(
            success: false,
            message:
                decodedJson['message'] ?? 'Erro ao obter resposta do servidor',
            statusCode: response.statusCode,
          );
        }

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
