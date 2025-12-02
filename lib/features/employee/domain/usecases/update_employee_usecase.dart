import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class UpdateEmployeeUseCase
    implements UseCase<EmployeeEntity, UpdateEmployeeParams> {
  UpdateEmployeeUseCase(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, EmployeeEntity>> call(
    final UpdateEmployeeParams params,
  ) => _repository.updateEmployee(params.id, params.employee);
}

class UpdateEmployeeParams {
  const UpdateEmployeeParams({required this.id, required this.employee});

  final int id;
  final EmployeeEntity employee;
}
