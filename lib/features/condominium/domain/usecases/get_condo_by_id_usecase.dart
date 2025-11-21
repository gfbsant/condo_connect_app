import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/condominium_entity.dart';
import '../repositories/condo_repository.dart';

@injectable
class GetCondoByIdUseCase
    implements UseCase<CondominiumEntity, GetCondoByIdParams> {
  const GetCondoByIdUseCase(this._repository);

  final CondoRepository _repository;

  @override
  Future<Either<Failure, CondominiumEntity>> call(
    final GetCondoByIdParams params,
  ) => _repository.getCondoById(params.id);
}

class GetCondoByIdParams {
  const GetCondoByIdParams({required this.id});

  final int id;
}
