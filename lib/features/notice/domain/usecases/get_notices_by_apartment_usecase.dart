import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/notice_entity.dart';
import '../repositories/notice_repository.dart';

@injectable
class GetNoticesByApartmentUseCase
    implements UseCase<List<NoticeEntity>, GetNoticesByApartmentParams> {
  const GetNoticesByApartmentUseCase(this._repository);

  final NoticeRepository _repository;

  @override
  Future<Either<Failure, List<NoticeEntity>>> call(
    final GetNoticesByApartmentParams params,
  ) => _repository.getNoticesByApartment(params.apartmentId);
}

class GetNoticesByApartmentParams {
  const GetNoticesByApartmentParams(this.apartmentId);

  final int apartmentId;
}
