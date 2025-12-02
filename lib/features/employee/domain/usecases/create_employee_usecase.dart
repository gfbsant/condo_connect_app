import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class CreateEmployeeUseCase
    implements UseCase<EmployeeEntity, CreateEmployeeParams> {
  CreateEmployeeUseCase(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, EmployeeEntity>> call(
    final CreateEmployeeParams params,
  ) => _repository.createEmployee(params.condominiumId, params.employee);
}

class CreateEmployeeParams {
  const CreateEmployeeParams({
    required this.condominiumId,
    required this.employee,
  });

  final int condominiumId;
  final EmployeeEntity employee;
}
