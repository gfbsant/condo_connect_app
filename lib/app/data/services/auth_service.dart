import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../core/constants/api_constants.dart';
import '../../core/exceptions/api_exception.dart';
import '../../core/services/base_http_service.dart';
import '../interfaces/auth_repository_interface.dart';
import '../interfaces/http_client_interface.dart';
import '../models/api_response.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

class AuthService extends BaseHttpService implements AuthRepositoryInterface {
  AuthService() : super(baseUrl: ApiConstants.baseUrl);

  @override
  Future<AuthResponse> login(
    final String email,
    final String password,
  ) async {
    final ApiResponse<AuthResponse> response = await makeRequest<AuthResponse>(
      RequestType.POST,
      '/auth/login',
      jsonBody: {
        'email': email,
        'password': password,
      },
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      fromJson: (final data) =>
          AuthResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(
        message: response.message ?? 'Erro no login',
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<void> logout(final String token) async {
    try {
      await makeRequest(
        RequestType.POST,
        '/auth/logout',
        headers: {
          ...buildAuthHeader(token),
          'Content-Type': 'application/json',
        },
      );
    } on Exception catch (e) {
      log('Erro ao fazer logout no servidor: $e');
    }
  }

  @override
  Future<AuthResponse> refreshToken(final String refreshToken) async {
    final ApiResponse<AuthResponse> response = await makeRequest<AuthResponse>(
      RequestType.POST,
      '/auth/refresh',
      jsonBody: {'refresh_token': refreshToken},
      headers: {'Content-Type': 'application/json'},
      fromJson: (data) => AuthResponse.fromJson(data as Map<String, dynamic>),
    );

    if (response.success && response.data != null) {
      return response.data!;
    } else {
      throw ApiException(
        message: response.message ?? 'Token expirado',
        statusCode: response.statusCode ?? 0,
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
    final Map<String, dynamic> requestBody = {
      'name': name,
      'email': email,
      'password': password,
      'cpf': cpf,
    };

    if (phone != null && phone.isNotEmpty) {
      requestBody['phone'] = phone;
    }

    final ApiResponse<Map<String, dynamic>> response =
        await makeRequest<Map<String, dynamic>>(
      RequestType.POST,
      '/auth/register',
      jsonBody: requestBody,
      headers: {'Content-Type': 'application/json'},
      fromJson: (final data) => data as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      return User.fromJson(response.data!['user'] as Map<String, dynamic>);
    } else {
      final String message = _getRegisterErrorMessage(response.statusCode);
      throw ApiException(
        message: response.message ?? message,
        statusCode: response.statusCode ?? 0,
      );
    }
  }

  @override
  Future<void> requestPasswordReset(final String email) async {
    final ApiResponse response = await makeRequest(
      RequestType.POST,
      '/auth/reset-password',
      jsonBody: {'email': email},
      headers: {'Content-Type': 'application/json'},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Erro ao solicitar recuperação');
    }
  }

  @override
  Future<void> confirmPasswordReset(
    final String token,
    final String newPassword,
  ) async {
    final ApiResponse response = await makeRequest(
      RequestType.POST,
      '/auth/reset-password/confirm',
      jsonBody: {
        'token': token,
        'new_password': newPassword,
      },
      headers: {'Content-Type': 'application/json'},
    );

    if (!response.success) {
      throw Exception(response.message ?? 'Erro ao confirmar nova senha');
    }
  }

  String _getRegisterErrorMessage(final int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Dados inválidos';
      case 409:
        return 'Email ou CPF já cadastrado';
      default:
        return 'Erro no cadastro';
    }
  }
}
