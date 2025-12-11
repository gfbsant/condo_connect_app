import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/facility_remote_datasource.dart';
import '../models/facility_model.dart';

@Injectable(as: FacilityRemoteDataSource)
class FacilityRemoteDataSourceImpl extends BaseHttpDataSource
    implements FacilityRemoteDataSource {
  String get _facilitiesPath => '/facilities';

  String get _condominiaPath => '/condominia';

  @override
  Future<FacilityModel> createFacility(
    final int condominiumId,
    final FacilityModel facility,
  ) async {
    try {
      final ApiResponse<FacilityModel> response = await makeRequest(
        RequestType.POST,
        '$_condominiaPath/$condominiumId$_facilitiesPath',
        jsonBody: facility.toJson(),
        fromJson: (final json) =>
            FacilityModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao criar área comum',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<List<FacilityModel>> getFacilitiesByCondo(
    final int condominiumId,
  ) async {
    try {
      final ApiResponse<List<FacilityModel>> response = await makeRequest(
        RequestType.GET,
        '$_condominiaPath/$condominiumId$_facilitiesPath',
        fromJson: (final data) {
          final items = data as List<dynamic>;
          return items
              .map(
                (final json) =>
                    FacilityModel.fromJson(json as Map<String, dynamic>),
              )
              .toList();
        },
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter área comum',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<FacilityModel> getFacilityById(final int facilityId) async {
    try {
      final ApiResponse<FacilityModel> response = await makeRequest(
        RequestType.GET,
        '$_facilitiesPath/$facilityId',
        fromJson: (final json) =>
            FacilityModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter área comum',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<FacilityModel> updateFacility(
    final int facilityId,
    final FacilityModel facility,
  ) async {
    try {
      final ApiResponse<FacilityModel> response = await makeRequest(
        RequestType.PUT,
        '$_facilitiesPath/$facilityId',
        jsonBody: facility.toJson(),
        fromJson: (final json) =>
            FacilityModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao atualizar área comum',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<void> deleteFacility(final int facilityId) async {
    try {
      final ApiResponse response = await makeRequest(
        .DELETE,
        '$_facilitiesPath/$facilityId',
      );
      if (response.success) {
        return;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao deletar área comum',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }
}
