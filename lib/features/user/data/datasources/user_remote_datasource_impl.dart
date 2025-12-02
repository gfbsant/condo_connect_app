import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/user_remote_datasource.dart';
import '../models/user_model.dart';

@Injectable(as: UserRemoteDataSource)
class UserRemoteDataSourceImpl extends BaseHttpDataSource
    implements UserRemoteDataSource {
  String get _usersPath => '/users';

  @override
  Future<UserModel> getUser(final int userId) async {
    try {
      final ApiResponse<UserModel> response = await makeRequest<UserModel>(
        RequestType.GET,
        '$_usersPath/$userId',
        fromJson: (final json) =>
            UserModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter usuario',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: 'Erro ao obter usuario: $e', statusCode: 0);
    }
  }

  @override
  Future<UserModel> updateUser(final int userId, final UserModel user) async {
    try {
      final ApiResponse<UserModel> response = await makeRequest<UserModel>(
        RequestType.PUT,
        '$_usersPath/$userId',
        jsonBody: user.toJson(),
        fromJson: (final json) =>
            UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao atualizar usuário',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao atualizar usuário: $e',
        statusCode: 0,
      );
    }
  }
}
