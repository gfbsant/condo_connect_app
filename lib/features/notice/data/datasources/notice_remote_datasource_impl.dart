import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../domain/datasources/notice_remote_datasource.dart';
import '../models/notice_model.dart';

@Injectable(as: NoticeRemoteDataSource)
class NoticeRemoteDataSourceImpl extends BaseHttpDataSource
    implements NoticeRemoteDataSource {
  @override
  Future<NoticeModel> createNotice(
    final int apartmentId,
    final NoticeModel notice,
  ) async {
    try {
      final ApiResponse<NoticeModel> response = await makeRequest(
        RequestType.POST,
        '$apartmentsPath/$apartmentId$noticesPath',
        fromJson: (final json) =>
            NoticeModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao criar aviso',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao criar aviso: $e');
    }
  }

  @override
  Future<List<NoticeModel>> getNoticesByCondo(final int condoId) async {
    try {
      final ApiResponse<List<NoticeModel>> response = await makeRequest(
        RequestType.GET,
        '$condominiaPath/$condoId$noticesPath',
        fromJson: (final data) {
          final items = data as List<dynamic>;
          return items.map((final json) => NoticeModel.fromJson(json)).toList();
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter avisos por condominio',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao obter avisos por condominio: $e');
    }
  }

  @override
  Future<List<NoticeModel>> getNoticesByApartment(final int apartmentId) async {
    try {
      final ApiResponse<List<NoticeModel>> response = await makeRequest(
        RequestType.GET,
        '$apartmentsPath/$apartmentId$noticesPath',
        fromJson: (final data) {
          final items = data as List<dynamic>;
          return items.map((final json) => NoticeModel.fromJson(json)).toList();
        },
      );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter avisos por apartamento',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao obter avisos por apartamento: $e');
    }
  }

  @override
  Future<NoticeModel> getNoticeById(final int id) async {
    try {
      final ApiResponse<NoticeModel> response = await makeRequest(
        RequestType.GET,
        '$noticesPath/$id',
        fromJson: (final json) =>
            NoticeModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter aviso',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao obter aviso: $e');
    }
  }

  @override
  Future<NoticeModel> updateNotice(
    final int id,
    final NoticeModel notice,
  ) async {
    try {
      final ApiResponse<NoticeModel> response = await makeRequest(
        RequestType.PUT,
        '$noticesPath/$id',
        fromJson: (final json) =>
            NoticeModel.fromJson(json as Map<String, dynamic>),
      );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao atualizar aviso',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao atualizar aviso: $e');
    }
  }

  @override
  Future<void> deleteNotice(final int id) async {
    try {
      await makeRequest(RequestType.DELETE, '$noticesPath/$id');
    } on ApiException {
      rethrow;
    } on Exception catch (e) {
      throw Exception('Erro ao apagar aviso: $e');
    }
  }
}
