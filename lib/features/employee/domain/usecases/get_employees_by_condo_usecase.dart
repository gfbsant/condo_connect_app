import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

@injectable
class GetEmployeesByCondoUseCase
    implements UseCase<List<EmployeeEntity>, GetEmployeesByCondoParams> {
  GetEmployeesByCondoUseCase(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, List<EmployeeEntity>>> call(
    final GetEmployeesByCondoParams params,
  ) => _repository.getEmployeesByCondo(params.condominiumId);
}

class GetEmployeesByCondoParams {
  const GetEmployeesByCondoParams({required this.condominiumId});

  final int condominiumId;
}
