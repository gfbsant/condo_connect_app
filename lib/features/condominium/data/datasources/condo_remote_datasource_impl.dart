import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/condo_remote_datasource.dart';
import '../models/condominium_model.dart';

@Injectable(as: CondoRemoteDataSource)
class CondoRemoteDataSourceImpl extends BaseHttpDataSource
    implements CondoRemoteDataSource {
  @override
  Future<CondominiumModel> createCondominium(
    final CondominiumModel condo,
  ) async {
    try {
      final ApiResponse<CondominiumModel> response =
          await makeRequest<CondominiumModel>(
            RequestType.POST,
            '/condominia',
            jsonBody: condo.toJson,
            fromJson: (final data) =>
                CondominiumModel.fromJson(data as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }

      throw ApiException(
        message: response.message ?? 'Erro ao criar condominio',
        statusCode: 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao criar condominio: $e');
    }
  }

  @override
  Future<List<CondominiumModel>> searchCondos({final String? query}) async {
    var path = '/condominia';
    if (query != null) {
      path = path += '?q=$query';
    }

    try {
      final ApiResponse<List<CondominiumModel>> response =
          await makeRequest<List<CondominiumModel>>(
            RequestType.GET,
            path,
            fromJson: (final data) {
              final items = data as List<dynamic>;
              return items
                  .map((final json) => CondominiumModel.fromJson(json))
                  .toList();
            },
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao obter condominios',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao obter condominios: $e');
    }
  }

  @override
  Future<CondominiumModel> getCondominiumById(final int id) async {
    try {
      final ApiResponse<CondominiumModel> response =
          await makeRequest<CondominiumModel>(
            RequestType.GET,
            '/condominia/$id',
            fromJson: (final data) =>
                CondominiumModel.fromJson(data as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao obter condominio',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao obter condominio: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<CondominiumModel> updateCondominium(
    final int id,
    final CondominiumModel condo,
  ) async {
    try {
      final ApiResponse<CondominiumModel> response = await makeRequest(
        RequestType.PUT,
        '/condominia/$id',
        fromJson: (final json) =>
            CondominiumModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao atualizarn condominio',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao atualizar condominio: $e');
    }
  }

  @override
  Future<void> deleteCondominium(final int id) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.DELETE,
        '/condominia/$id',
      );
      if (response.success) {
        return;
      }
      throw ApiException(
        message: 'Erro ao apagar condominio',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao deletar condominio: $e');
    }
  }
}
