import 'package:injectable/injectable.dart';

import '../../../../core/clients/http_client.dart';
import '../../../../core/exceptions/api_exception.dart';
import '../../../../core/models/api_response.dart';
import '../../../../core/services/base_http_datasource.dart';
import '../../domain/datasources/employee_remote_datasource.dart';
import '../models/employee_model.dart';

@Injectable(as: EmployeeRemoteDataSource)
class EmployeeRemoteDataSourceImpl extends BaseHttpDataSource
    implements EmployeeRemoteDataSource {
  String get _condominiaPath => '/condominia';

  String get _employeesPath => '/employees';

  @override
  Future<EmployeeModel> createEmployee(
    final int condominiumId,
    final EmployeeModel employee,
  ) async {
    try {
      final ApiResponse<EmployeeModel> response =
          await makeRequest<EmployeeModel>(
            RequestType.POST,
            '$_condominiaPath/$condominiumId$_employeesPath',
            jsonBody: employee.toJson(),
            fromJson: (final json) =>
                EmployeeModel.fromJson(json as Map<String, dynamic>),
          );

      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao criar funcionaro',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao criar funcionario: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<List<EmployeeModel>> getEmployeesByCondo(
    final int condominiumId,
  ) async {
    try {
      final ApiResponse<List<EmployeeModel>> response =
          await makeRequest<List<EmployeeModel>>(
            RequestType.GET,
            '$_condominiaPath/$condominiumId$_employeesPath',
            fromJson: (final data) {
              final items = data as List<dynamic>;
              return items
                  .map(
                    (final json) =>
                        EmployeeModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();
            },
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: 'Erro ao obter funcionarios',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao obter funcionarios: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<EmployeeModel> getEmployeeById(final int employeeId) async {
    try {
      final ApiResponse<EmployeeModel> response =
          await makeRequest<EmployeeModel>(
            RequestType.GET,
            '$_employeesPath/$employeeId',
            fromJson: (final json) =>
                EmployeeModel.fromJson(json as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao obter funcionario',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao obter funcionario: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<EmployeeModel> updateEmployee(
    final int id,
    final EmployeeModel employee,
  ) async {
    try {
      final ApiResponse<EmployeeModel> response =
          await makeRequest<EmployeeModel>(
            RequestType.PUT,
            '$_employeesPath/$id',
            jsonBody: employee.toJson(),
            fromJson: (final json) =>
                EmployeeModel.fromJson(json as Map<String, dynamic>),
          );
      if (response.success && response.data != null) {
        return response.data!;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao atualizar funcionario',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao atualizar funcionario: $e',
        statusCode: 0,
      );
    }
  }

  @override
  Future<void> deleteEmployee(final int employeeId) async {
    try {
      final Map<String, String> authHeader = await buildAuthHeaderFromStorage();
      final ApiResponse response = await makeRequest(
        RequestType.DELETE,
        '$_employeesPath/$employeeId',
        headers: authHeader,
      );

      if (response.success) {
        return;
      }
      throw ApiException(
        message: response.message ?? 'Erro ao deletar funcionario',
        statusCode: response.statusCode ?? 0,
      );
    } on ApiException catch (_) {
      rethrow;
    } on Exception catch (e) {
      throw ApiException(
        message: 'Erro ao deletar funcionario: $e',
        statusCode: 0,
      );
    }
  }
}
