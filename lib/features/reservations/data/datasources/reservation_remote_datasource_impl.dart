import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../../shared/models/api_response.dart';
import '../../domain/datasources/reservation_remote_datasource.dart';
import '../models/reservation_model.dart';

@Injectable(as: ReservationRemoteDataSource)
class ReservationRemoteDataSourceImpl extends BaseHttpDataSource
    implements ReservationRemoteDataSource {
  @override
  Future<ReservationModel> createReservation(
    final int facilityId,
    final ReservationModel reservation,
  ) async {
    try {
      final ApiResponse<ReservationModel> response =
          await makeRequest<ReservationModel>(
            RequestType.POST,
            '$facilitiesPath/$facilityId$reservationsPath',
          );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao criar reserva',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<List<ReservationModel>> getReservationsByApartment(
    final int apartmentId,
  ) async {
    try {
      final ApiResponse<List<ReservationModel>> response =
          await makeRequest<List<ReservationModel>>(
            .GET,
            '$apartmentsPath/$apartmentId$reservationsPath',
            fromJson: (final data) {
              final items = data as List<dynamic>;
              return items
                  .map(
                    (final json) =>
                        ReservationModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            },
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter reservas',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<List<ReservationModel>> getReservationsByFacility(
    final int facilityId,
  ) async {
    try {
      final ApiResponse<List<ReservationModel>> response =
          await makeRequest<List<ReservationModel>>(
            RequestType.GET,
            '$facilitiesPath/$facilityId$reservationsPath',
            fromJson: (final data) {
              final items = data as List<dynamic>;
              return items
                  .map(
                    (final json) =>
                        ReservationModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            },
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter reservas',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }

  @override
  Future<void> deleteReservation(final int reservationId) async {
    try {
      final ApiResponse response = await makeRequest(
        RequestType.DELETE,
        '$reservationsPath/$reservationId',
      );
      if (response.success) {
        return;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao deletar reserva',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(message: e.toString(), statusCode: 0);
    }
  }
}
