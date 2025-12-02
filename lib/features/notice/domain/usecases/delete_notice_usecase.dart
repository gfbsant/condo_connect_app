import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/usecase/usecase.dart';
import '../repositories/notice_repository.dart';

@injectable
class DeleteNoticeUseCase implements UseCase<void, DeleteNoticeParams> {
  const DeleteNoticeUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, void>> call(final DeleteNoticeParams params) =>
      _repository.deleteNotice(params.id);
}

class DeleteNoticeParams {
  const DeleteNoticeParams(this.id);

  final int id;
}
