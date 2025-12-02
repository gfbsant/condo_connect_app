import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/employee_repository.dart';

@injectable
class DeleteEmployeeUseCase implements UseCase<void, DeleteEmployeeParams> {
  DeleteEmployeeUseCase(this._repository);

  final EmployeeRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteEmployeeParams params) =>
      _repository.deleteEmployee(params.id);
}

class DeleteEmployeeParams {
  const DeleteEmployeeParams({required this.id});

  final int id;
}
