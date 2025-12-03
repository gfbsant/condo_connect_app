import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/resident_entity.dart';
import '../repositories/resident_repository.dart';

@injectable
class CreateResidentUseCase
    implements UseCase<ResidentEntity, CreateResidentParams> {
  const CreateResidentUseCase(this._repository);

  final ResidentRepository _repository;

  @override
  Future<Either<Failure, ResidentEntity>> call(
    final CreateResidentParams params,
  ) => _repository.createResident(params.apartmentId, params.email);
}

class CreateResidentParams {
  const CreateResidentParams({required this.apartmentId, required this.email});

  final int apartmentId;
  final String email;
}
