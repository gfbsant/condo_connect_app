import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/condo_repository.dart';

@injectable
class DeleteCondoUseCase implements UseCase<void, DeleteCondoParams> {
  DeleteCondoUseCase(this._repository);

  final CondoRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteCondoParams params) =>
      _repository.deleteCondo(params.id);
}

class DeleteCondoParams {
  const DeleteCondoParams({required this.id});

  final int id;
}
