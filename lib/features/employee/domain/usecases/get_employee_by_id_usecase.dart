import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class GetEmployeeByIdUseCase
    implements UseCase<EmployeeEntity, GetEmployeeByIdParams> {
  GetEmployeeByIdUseCase(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, EmployeeEntity>> call(
    final GetEmployeeByIdParams params,
  ) => _repository.getEmployeeById(params.employeeId);
}

class GetEmployeeByIdParams {
  const GetEmployeeByIdParams({required this.employeeId});

  final int employeeId;
}
