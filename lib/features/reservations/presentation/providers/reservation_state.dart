import 'package:equatable/equatable.dart';

import '../../domain/entities/reservation_entity.dart';

enum ReservationStatus { initial, loading, searching, suceess, error }

class ReservationState extends Equatable {
  const ReservationState({
    required this.status,
    this.reservations = const [],
    this.errorMessage,
    this.successMessage,
  });

  const ReservationState.initial()
    : status = .initial,
      reservations = const [],
      errorMessage = null,
      successMessage = null;

  final ReservationStatus status;
  final List<ReservationEntity> reservations;
  final String? errorMessage;
  final String? successMessage;

  ReservationState copyWith({
    final ReservationStatus? status,
    final List<ReservationEntity>? reservations,
    final String? errorMessage,
    final String? successMessage,
    final bool clearMessages = false,
  }) => ReservationState(
    status: status ?? this.status,
    reservations: reservations ?? this.reservations,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    reservations,
    errorMessage,
    successMessage,
  ];
}
