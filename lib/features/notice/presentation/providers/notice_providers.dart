import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/injection_container.dart';
import '../../domain/entities/notice_entity.dart';
import '../../domain/usecases/create_notice_usecase.dart';
import '../../domain/usecases/delete_notice_usecase.dart';
import '../../domain/usecases/get_notice_by_id_usecase.dart';
import '../../domain/usecases/get_notices_by_apartment_usecase.dart';
import '../../domain/usecases/get_notices_by_condo_usecase.dart';
import '../../domain/usecases/update_notice_usecase.dart';
import 'notice_notifier.dart';
import 'notice_state.dart';

final Provider<CreateNoticeUseCase> createNoticeUseCaseProvider =
    Provider.autoDispose<CreateNoticeUseCase>(
      (final ref) => getIt<CreateNoticeUseCase>(),
    );

final Provider<GetNoticesByApartmentUseCase>
getNoticesByApartmentUseCaseProvider =
    Provider.autoDispose<GetNoticesByApartmentUseCase>(
      (final ref) => getIt<GetNoticesByApartmentUseCase>(),
    );

final Provider<GetNoticesByCondoUseCase> getNoticesByCondoUseCaseProvider =
    Provider.autoDispose<GetNoticesByCondoUseCase>(
      (final ref) => getIt<GetNoticesByCondoUseCase>(),
    );

final Provider<GetNoticeByIdUseCase> getNoticeByIdUseCaseProvider =
    Provider.autoDispose<GetNoticeByIdUseCase>(
      (final ref) => getIt<GetNoticeByIdUseCase>(),
    );

final Provider<UpdateNoticeUseCase> updateNoticeUseCaseProvider =
    Provider.autoDispose<UpdateNoticeUseCase>(
      (final ref) => getIt<UpdateNoticeUseCase>(),
    );

final Provider<DeleteNoticeUseCase> deleteNoticeUseCaseProvider =
    Provider.autoDispose<DeleteNoticeUseCase>(
      (final ref) => getIt<DeleteNoticeUseCase>(),
    );

// Main notifier
final NotifierProvider<NoticeNotifier, NoticeState> noticeNotifierProvider =
    NotifierProvider.autoDispose<NoticeNotifier, NoticeState>(
      NoticeNotifier.new,
    );

// Helpers
final Provider<NoticeNotifier> noticeNotifierAccessor =
    Provider.autoDispose<NoticeNotifier>(
      (final ref) => ref.watch(noticeNotifierProvider.notifier),
    );

final Provider<List<NoticeEntity>> noticesProvider =
    Provider.autoDispose<List<NoticeEntity>>(
      (final ref) => ref.watch(noticeNotifierProvider).notices,
    );

final Provider<NoticeEntity?> selectedNoticeProvider =
    Provider.autoDispose<NoticeEntity?>(
      (final ref) => ref.watch(noticeNotifierProvider).selectedNotice,
    );

final Provider<bool> isLoadingProvider = Provider.autoDispose<bool>(
  (final ref) =>
      ref.watch(noticeNotifierProvider).status == NoticeStatus.loading,
);

final Provider<String?> errorMessageProvider = Provider.autoDispose<String?>(
  (final ref) => ref.watch(noticeNotifierProvider).errorMessage,
);

final Provider<String?> successMessageProvider = Provider.autoDispose<String?>(
  (final ref) => ref.watch(noticeNotifierProvider).successMessage,
);
