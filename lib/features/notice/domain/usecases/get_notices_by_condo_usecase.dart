import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

@injectable
class GetNoticesByCondoUseCase
    implements UseCase<List<NoticeEntity>, GetNoticesByCondoParams> {
  const GetNoticesByCondoUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, List<NoticeEntity>>> call(
    final GetNoticesByCondoParams params,
  ) => _repository.getNoticesByCondo(params.condoId);
}

class GetNoticesByCondoParams {
  const GetNoticesByCondoParams(this.condoId);

  final int condoId;
}
