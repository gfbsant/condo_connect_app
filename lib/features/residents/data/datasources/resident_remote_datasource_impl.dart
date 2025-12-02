import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/resident_remote_datasource.dart';
import '../models/resident_model.dart';

@Injectable(as: ResidentRemoteDataSource)
class ResidentRemoteDataSourceImpl extends BaseHttpDataSource
    implements ResidentRemoteDataSource {
  String get _residentsPath => '/residents';

  String get _apartmentsPath => '/apartment';

  @override
  Future<ResidentModel> createResident(
    final int apartmentId,
    final int userId,
  ) async {
    try {
      final ApiResponse<ResidentModel> response = await makeRequest(
        RequestType.POST,
        '$_apartmentsPath/$apartmentId$_residentsPath',
        jsonBody: {'userId': userId},
        fromJson: (final json) =>
            ResidentModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao criar morador',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<List<ResidentModel>> getResidentsByApartment(
    final int apartmentId,
  ) async {
    try {
      final ApiResponse<List<ResidentModel>> response = await makeRequest(
        RequestType.GET,
        '$_apartmentsPath/$apartmentId$_residentsPath',
        fromJson: (final data) {
          final items = data as List<dynamic>;
          return items
              .map(
                (final json) =>
                    ResidentModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter moradores',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<ResidentModel> getResidentById(
    final int apartmentId,
    final int residentId,
  ) async {
    try {
      final ApiResponse<ResidentModel> response = await makeRequest(
        RequestType.GET,
        '$_apartmentsPath/$apartmentId$_residentsPath/$residentId',
        fromJson: (final json) =>
            ResidentModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter morador',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<ResidentModel> updateResident(
    final int apartmentId,
    final int residentId,
    final ResidentModel resident,
  ) async {
    try {
      final ApiResponse<ResidentModel> response = await makeRequest(
        RequestType.PUT,
        '$_apartmentsPath/$apartmentId$_residentsPath/$residentId',
        jsonBody: resident.toJson(),
        fromJson: (final json) =>
            ResidentModel.fromJson(json as Map<String, dynamic>),
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao atualizar morador',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<void> deleteResident(
    final int apartmentId,
    final int residentId,
  ) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.DELETE,
        '$_apartmentsPath/$apartmentId$_residentsPath/$residentId',
      );
      if (response.success) {
        return;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao deletar morador',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }
}
