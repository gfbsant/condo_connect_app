import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/apartment_entity.dart';
import '../repositories/apartment_repository.dart';

@injectable
class GetApartmentsByCondoUseCase
    implements UseCase<List<ApartmentEntity>, GetApartmentsByCondoParams> {
  const GetApartmentsByCondoUseCase(this._repository);

  final ApartmentRepository _repository;

  @override
  Future<Either<Failure, List<ApartmentEntity>>> call(
    final GetApartmentsByCondoParams params,
  ) => _repository.getApartmentsByCondo(params.condominiumId, params.query);
}

class GetApartmentsByCondoParams {
  const GetApartmentsByCondoParams({required this.condominiumId, this.query});

  final int condominiumId;
  final Map<String, String>? query;
}
