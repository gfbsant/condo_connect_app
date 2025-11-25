import 'package:equatable/equatable.dart';

import '../../domain/entities/notice_entity.dart';

enum NoticeStatus { initial, loading, searching, success, error }

class NoticeState extends Equatable {
  const NoticeState({
    required this.status,
    this.notices = const [],
    this.selectedNotice,
    this.errorMessage,
    this.successMessage,
  });

  const NoticeState.initial()
    : status = NoticeStatus.initial,
      notices = const [],
      selectedNotice = null,
      errorMessage = null,
      successMessage = null;

  final NoticeStatus status;
  final List<NoticeEntity> notices;
  final NoticeEntity? selectedNotice;
  final String? errorMessage;
  final String? successMessage;

  NoticeState copyWith({
    final NoticeStatus? status,
    final List<NoticeEntity>? notices,
    final NoticeEntity? selectedNotice,
    final String? errorMessage,
    final String? successMessage,
    final bool clearSelectedNotice = false,
    final bool clearMessages = false,
  }) => NoticeState(
    status: status ?? this.status,
    notices: notices ?? this.notices,
    selectedNotice: clearSelectedNotice
        ? null
        : selectedNotice ?? this.selectedNotice,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    notices,
    selectedNotice,
    errorMessage,
    successMessage,
  ];
}
