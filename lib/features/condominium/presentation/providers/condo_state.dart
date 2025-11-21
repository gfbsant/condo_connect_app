import 'package:equatable/equatable.dart';

import '../../domain/entities/condominium_entity.dart';

enum CondoStatus { initial, loading, searching, requestingJoin, success, error }

class CondoState extends Equatable {
  const CondoState({
    required this.status,
    this.condos = const [],
    this.selectedCondo,
    this.hasJoinRequest,
    this.errorMessage,
    this.successMessage,
  });

  const CondoState.initial()
    : status = CondoStatus.initial,
      condos = const [],
      selectedCondo = null,
      hasJoinRequest = null,
      errorMessage = null,
      successMessage = null;

  final CondoStatus status;
  final List<CondominiumEntity> condos;
  final CondominiumEntity? selectedCondo;
  final bool? hasJoinRequest;
  final String? errorMessage;
  final String? successMessage;

  CondoState copyWith({
    final CondoStatus? status,
    final List<CondominiumEntity>? condos,
    final CondominiumEntity? selectedCondo,
    final bool? hasJoinRequest,
    final String? errorMessage,
    final String? successMessage,
    final bool clearSelectedCondo = false,
    final bool clearMessages = false,
  }) => CondoState(
    status: status ?? this.status,
    condos: condos ?? this.condos,
    selectedCondo: clearSelectedCondo
        ? null
        : (selectedCondo ?? this.selectedCondo),
    errorMessage: clearMessages ? null : (errorMessage ?? this.errorMessage),
    successMessage: clearMessages
        ? null
        : (successMessage ?? this.successMessage),
  );

  @override
  List<Object?> get props => [
    status,
    condos,
    selectedCondo,
    hasJoinRequest,
    errorMessage,
    successMessage,
  ];
}
