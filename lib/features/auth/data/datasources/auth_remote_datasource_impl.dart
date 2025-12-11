import 'dart:developer';

import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../../user/data/models/user_model.dart';
import '../../domain/datasources/auth_remote_datasource.dart';
import '../models/login_response_model.dart';
import '../models/permission_model.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl extends BaseHttpDataSource
    implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(final String email, final String password) async {
    try {
      final ApiResponse<LoginResponseModel> response =
          await makeRequest<LoginResponseModel>(
            RequestType.POST,
            '/user/login',
            jsonBody: {'email': email, 'password': password},
            fromJson: (final json) =>
                LoginResponseModel.fromJson(json as Map<String, dynamic>),
          );

      if (response.success && response.data != null) {
        final String? accessToken = response.headers?['authorization']
            ?.replaceAll('Authorization ', '');
        if (accessToken == null) {
          throw ApiException(message: 'Token não disponível', statusCode: 0);
        }

        await persistAuthHeader(accessToken);
        return response.data!.user;
      }
      throw ApiException(
        message: response.message ?? 'Erro no login',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao fazer login: $e');
    }
  }

  @override
  Future<List<PermissionModel>> getUserPermissions() async {
    try {
      final ApiResponse<List<PermissionModel>> response = await makeRequest(
        RequestType.GET,
        '/users/me/permissions',
        fromJson: (final data) {
          final items = data as List<dynamic>;
          return items
              .map((final json) => PermissionModel.fromJson(json))
              .toList();
        },
      );
      if (response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter permissoes',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao obter permissoes: $e');
    }
  }

  @override
  Future<UserModel> register({required final UserModel user}) async {
    try {
      final ApiResponse<UserModel> response = await makeRequest<UserModel>(
        RequestType.POST,
        '/users',
        jsonBody: {'user': user.toJson()},
        fromJson: (final json) =>
            UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      } else {
        throw ApiException(
          message:
              response.message ?? _getRegisterErrorMessage(response.statusCode),
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao registrar usuário: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await clearAccessToken();
    } on Exception catch (e) {
      log('Erro ao fazer logout: $e');
    }
  }

  @override
  Future<void> requestPasswordReset(final String email) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.POST,
        '/user/password',
        jsonBody: {'email': email},
        headers: {'Content-Type': 'application/json'},
      );

      if (!response.success) {
        throw ApiException(
          message: response.message ?? 'Erro ao solicitar recuperação',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao solicitar recuperacão: $e');
    }
  }

  @override
  Future<void> resetPassword(
    final String token,
    final String newPassword,
  ) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.PUT,
        '/user/password',
        jsonBody: {
          'user': {
            'resetPasswordToken': token,
            'password': newPassword,
            'passwordConfirmation': newPassword,
          },
        },
        headers: {'Content-Type': 'application/json'},
      );

      if (!response.success) {
        throw ApiException(
          message: response.message ?? 'Erro ao confirmar nova senha',
          statusCode: response.statusCode ?? 0,
        );
      }
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao confirmar nova senha: $e');
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
