import 'package:equatable/equatable.dart';

import '../../domain/entities/resident_entity.dart';

enum ResidentStatus { initial, loading, searching, success, error }

class ResidentState extends Equatable {
  const ResidentState({
    required this.status,
    this.residents = const [],
    this.selectedResident,
    this.errorMessage,
    this.successMessage,
  });

  const ResidentState.initial()
    : status = .initial,
      residents = const [],
      selectedResident = null,
      errorMessage = null,
      successMessage = null;

  final ResidentStatus status;
  final List<ResidentEntity> residents;
  final ResidentEntity? selectedResident;
  final String? errorMessage;
  final String? successMessage;

  ResidentState copyWith({
    final ResidentStatus? status,
    final List<ResidentEntity>? residents,
    final ResidentEntity? selectedResident,
    final String? errorMessage,
    final String? successMessage,
    final bool clearMessages = false,
    final bool clearSelectedResident = false,
  }) => ResidentState(
    status: status ?? this.status,
    residents: residents ?? this.residents,
    selectedResident: clearSelectedResident
        ? null
        : selectedResident ?? this.selectedResident,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    residents,
    selectedResident,
    errorMessage,
    successMessage,
  ];
}
