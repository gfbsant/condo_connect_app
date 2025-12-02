import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/condominium_entity.dart';
import '../repositories/condo_repository.dart';

@injectable
class SearchCondosUseCase
    implements UseCase<List<CondominiumEntity>, SearchCondosParams> {
  const SearchCondosUseCase(this._repository);

  final CondoRepository _repository;

  @override
  Future<Either<Failure, List<CondominiumEntity>>> call(
    final SearchCondosParams params,
  ) => _repository.searchCondos(query: params.query);
}

class SearchCondosParams {
  SearchCondosParams({this.query});

  final String? query;
}
