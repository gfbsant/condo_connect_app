import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/exceptions/api_exception.dart';
import '../interfaces/auth_repository_interface.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthRepository implements AuthRepositoryInterface {
  AuthRepository({final http.Client? client})
      : _client = client ?? http.Client();
  final http.Client _client;

  @override
  Future<AuthResponse> login({
    required final String email,
    required final String password,
  }) async {
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
          statusCode: response.statusCode,
        );
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
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Ocorreu um erro inesperado.',
        statusCode: 0,
      );
    }
  }

  @override
  Future<void> logout(final String token) async {
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

  @override
  Future<AuthResponse> refreshToken(final String refreshToken) async {
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
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Erro ao renovar sessão.',
        statusCode: 0,
      );
    }
  }

  @override
  Future<User> register({
    required final String name,
    required final String email,
    required final String password,
    required final String cpf,
    final String? phone,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'name': name,
        'email': email,
        'password': password,
        'cpf': cpf,
      };

      if (phone != null && phone.isNotEmpty) {
        requestBody['phone'] = phone;
      }

      final http.Response response = await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl}/auth/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(ApiConstants.timeout);

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return User.fromJson(data['user'] as Map<String, dynamic>);
      } else if (response.statusCode == 400) {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException(
          message: error['message'] ?? 'Dados inválidos',
          statusCode: 400,
        );
      } else if (response.statusCode == 409) {
        throw ApiException(
          message: 'Email ou CPF já cadastrado',
          statusCode: 409,
        );
      } else {
        final error = jsonDecode(response.body) as Map<String, dynamic>;
        throw ApiException(
          message: error['message'] ?? 'Erro no cadastro',
          statusCode: response.statusCode,
        );
      }
    } on TimeoutException {
      throw ApiException(
        message: 'Tempo de conexão esgotado. Verifique sua internet',
        statusCode: 400,
      );
    } on SocketException {
      throw ApiException(
        message: 'Erro de conexão. Verifique se o servidor está online',
        statusCode: 0,
      );
    } on Exception catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(message: 'Ocorreu um erro inesperado', statusCode: 0);
    }
  }

  @override
  Future<void> requestPasswordReset(final String email) async {
    try {
      final Uri uri = Uri.parse('${ApiConstants.baseUrl}/auth/reset-password');
      final http.Response response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode != 200) {
        final dynamic error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao solicitar recuperação');
      }
    } on Exception catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  @override
  Future<void> confirmPasswordReset(
      final String token, final String newPassword) async {
    try {
      final Uri uri =
          Uri.parse('${ApiConstants.baseUrl}/auth/reset-password/confirm');
      final http.Response response = await _client.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'token': token,
          'new_password': newPassword,
        }),
      );

      if (response.statusCode != 200) {
        final dynamic error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao confirmar nova senha');
      }
    } on Exception catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}
