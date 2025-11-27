import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, EmployeeEntity>> createEmployee(
    final int condominiumId,
    final EmployeeEntity employee,
  );

  Future<Either<Failure, List<EmployeeEntity>>> getEmployeesByCondo(
    final int condominiumId,
  );

  Future<Either<Failure, EmployeeEntity>> getEmployeeById(final int employeeId);

  Future<Either<Failure, EmployeeEntity>> updateEmployee(
    final int id,
    final EmployeeEntity employee,
  );

  Future<Either<Failure, void>> deleteEmployee(final int id);
}
