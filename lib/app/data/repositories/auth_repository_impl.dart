import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:condo_connect/app/core/constants/api_constants.dart';
import 'package:condo_connect/app/core/exceptions/api_exception.dart';
import 'package:condo_connect/app/data/models/auth_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final http.Client _client;

  AuthService({http.Client? client}) : _client = client ?? http.Client();

  Future<AuthResponse> login(
      {required String email, required String password}) async {
    try {
      final http.Response response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/auth/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw ApiException(message: 'Credenciais inválidas', statusCode: 401);
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException(
            message: error['message'] ?? 'Erro no login',
            statusCode: response.statusCode);
      }
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de conexão esgotado. Verifique sua internet.',
        statusCode: 408,
      );
    } on SocketException {
      throw ApiException(
        message: 'Erro de conexão. Verifique se o servidor está online.',
        statusCode: 0,
      );
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Ocorreu um erro inesperado.',
        statusCode: 0,
      );
    }
  }

  Future<void> logout(String token) async {
    try {
      await _client.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(ApiConstants.timeout);
    } on Exception catch (e) {
      log('Erro ao fazer logout no servidor: $e');
    }
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final http.Response response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/auth/refresh'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return AuthResponse.fromJson(data);
      } else {
        throw ApiException(
          message: 'Token expirado',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de conexão esgotado.',
        statusCode: 408,
      );
    } on SocketException {
      throw ApiException(
        message: 'Erro de conexão com o servidor.',
        statusCode: 0,
      );
    } on Exception catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        message: 'Erro ao renovar sessão.',
        statusCode: 0,
      );
    }
  }
}
