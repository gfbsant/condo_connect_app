import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

@injectable
class UpdateNoticeUseCase implements UseCase<NoticeEntity, UpdateNoticeParams> {
  const UpdateNoticeUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, NoticeEntity>> call(final UpdateNoticeParams params) =>
      _repository.updateNotice(params.id, params.notice);
}

class UpdateNoticeParams {
  const UpdateNoticeParams(this.id, this.notice);

  final int id;
  final NoticeEntity notice;
}
