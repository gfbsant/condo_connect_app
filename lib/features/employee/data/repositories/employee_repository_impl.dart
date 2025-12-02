import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../domain/datasources/employee_remote_datasource.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/repositories/employee_repository.dart';
import '../models/employee_model.dart';

@Injectable(as: EmployeeRepository)
class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this.remoteDataSource);

  final EmployeeRemoteDataSource remoteDataSource;
  @override
  Future<Either<Failure, EmployeeEntity>> createEmployee(
    final int condominiumId,
    final EmployeeEntity employee,
  ) async {
    try {
      final EmployeeModel result = await remoteDataSource.createEmployee(
        condominiumId,
        EmployeeModel.fromEntity(employee),
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao criar funcionario: $e'));
    }
  }

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByCondo(
    final int condominiumId,
  ) async {
    try {
      final List<EmployeeModel> result = await remoteDataSource
          .getEmployeesByCondo(condominiumId);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter funcionarios: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> getEmployeeById(
    final int employeeId,
  ) async {
    try {
      final EmployeeEntity result = await remoteDataSource.getEmployeeById(
        employeeId,
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao obter funcionario: $e'));
    }
  }

  @override
  Future<Either<Failure, EmployeeEntity>> updateEmployee(
    final int id,
    final EmployeeEntity employee,
  ) async {
    try {
      final EmployeeEntity result = await remoteDataSource.updateEmployee(
        id,
        EmployeeModel.fromEntity(employee),
      );
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao atualizar funcionario: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(final int id) async {
    try {
      await remoteDataSource.deleteEmployee(id);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao deletar funcionario: $e'));
    }
  }
}
