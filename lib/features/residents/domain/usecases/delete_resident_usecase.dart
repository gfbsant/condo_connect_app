import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/resident_repository.dart';

@injectable
class DeleteResidentUseCase implements UseCase<void, DeleteResidentParams> {
  const DeleteResidentUseCase(this._repository);

  final ResidentRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteResidentParams params) =>
      _repository.deleteResident(params.apartmentId, params.residentId);
}

class DeleteResidentParams {
  const DeleteResidentParams({
    required this.apartmentId,
    required this.residentId,
  });

  final int apartmentId;
  final int residentId;
}
