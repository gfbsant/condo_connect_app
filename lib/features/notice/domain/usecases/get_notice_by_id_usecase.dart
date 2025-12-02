import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

@injectable
class GetNoticeByIdUseCase
    implements UseCase<NoticeEntity, GetNoticeByIdParams> {
  const GetNoticeByIdUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, NoticeEntity>> call(
    final GetNoticeByIdParams params,
  ) => _repository.getNoticeById(params.id);
}

class GetNoticeByIdParams {
  const GetNoticeByIdParams(this.id);

  final int id;
}
