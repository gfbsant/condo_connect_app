import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

@injectable
class CreateNoticeUseCase implements UseCase<NoticeEntity, CreateNoticeParams> {
  const CreateNoticeUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, NoticeEntity>> call(final CreateNoticeParams params) =>
      _repository.createNotice(params.apartmentId, params.notice);
}

class CreateNoticeParams {
  const CreateNoticeParams(this.apartmentId, this.notice);

  final int apartmentId;
  final NoticeEntity notice;
}
