import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class CreateApartmentUseCase
    implements UseCase<ApartmentEntity, CreateApartmentParams> {
  const CreateApartmentUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, ApartmentEntity>> call(
    final CreateApartmentParams params,
  ) => _repository.createApartment(params.condominiumId, params.apartment);
}

class CreateApartmentParams {
  const CreateApartmentParams({
    required this.condominiumId,
    required this.apartment,
  });

  final int condominiumId;
  final ApartmentEntity apartment;
}
