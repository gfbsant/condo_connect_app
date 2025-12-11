import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/apartment_remote_datasource.dart';
import '../models/apartment_model.dart';

@Injectable(as: ApartmentRemoteDataSource)
class ApartmentRemoteDataSourceImpl extends BaseHttpDataSource
    implements ApartmentRemoteDataSource {
  @override
  Future<ApartmentModel> createApartment(
    final int condominiumId,
    final ApartmentModel apartment,
  ) async {
    try {
      final ApiResponse<ApartmentModel> response = await makeRequest(
        RequestType.POST,
        '$condominiaPath/$condominiumId$apartmentsPath',
        jsonBody: apartment.toJson(),
        fromJson: (final json) =>
            ApartmentModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao criar apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao criar apartamentos: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<List<ApartmentModel>> getApartmentsByCondo(
    final int condominiumId,
    final Map<String, String>? query,
  ) async {
    try {
      final ApiResponse<List<ApartmentModel>> response =
          await makeRequest<List<ApartmentModel>>(
            RequestType.GET,
            '$condominiaPath/$condominiumId$apartmentsPath',
            queryParams: query,
            fromJson: (final data) {
              final items = data as List<dynamic>;
              return items
                  .map(
                    (final json) =>
                        ApartmentModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            },
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao obter apartamentos',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception {
      throw ApiException(message: 'Erro ao obter apartamentos', statusCode: 0);
    }
  }

  @override
  Future<ApartmentModel> getApartmentById(final int apartmentId) async {
    try {
      final ApiResponse<ApartmentModel> response =
          await makeRequest<ApartmentModel>(
            RequestType.GET,
            '$apartmentsPath/$apartmentId',
            fromJson: (final json) =>
                ApartmentModel.fromJson(json as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao obter apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao obter apartamento: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<ApartmentModel> updateApartment(
    final int apartmentId,
    final ApartmentModel apartment,
  ) async {
    try {
      final ApiResponse<ApartmentModel> response =
          await makeRequest<ApartmentModel>(
            RequestType.PUT,
            '$apartmentsPath/$apartmentId',
            jsonBody: apartment.toJson(),
            fromJson: (final json) =>
                ApartmentModel.fromJson(json as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao atualizar apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao atualizar apartamento: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<ApartmentModel> approveApartment(final int apartmentId) async {
    try {
      final ApiResponse<ApartmentModel> response = await makeRequest(
        RequestType.PATCH,
        '$apartmentsPath/$apartmentId/approve',
        fromJson: (final json) =>
            ApartmentModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao aprovar apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<void> deleteApartment(final int apartmentId) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.DELETE,
        '$apartmentsPath/$apartmentId',
      );
      if (response.success) {
        return;
      }
      throw ApiException(
        message: 'Erro ao deletar apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao deletar apartamento: $e',
        statusCode: 0,
      );
    }
  }
}
