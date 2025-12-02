import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class GetApartmentByIdUseCase
    extends UseCase<ApartmentEntity, GetApartmentByIdParams> {
  GetApartmentByIdUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, ApartmentEntity>> call(
    final GetApartmentByIdParams params,
  ) => _repository.getApartmentById(params.apartmentId);
}

class GetApartmentByIdParams {
  const GetApartmentByIdParams({required this.apartmentId});

  final int apartmentId;
}
