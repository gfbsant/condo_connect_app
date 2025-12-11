import 'package:equatable/equatable.dart';

import '../../domain/entities/facility_entity.dart';

enum FacilityStatus { initial, loading, success, searching, error }

class FacilityState extends Equatable {
  const FacilityState({
    required this.status,
    this.facilities = const [],
    this.selectedFacility,
    this.errorMessage,
    this.successMessage,
  });

  const FacilityState.initial()
    : status = .initial,
      facilities = const [],
      selectedFacility = null,
      errorMessage = null,
      successMessage = null;

  final FacilityStatus status;
  final List<FacilityEntity> facilities;
  final FacilityEntity? selectedFacility;
  final String? errorMessage;
  final String? successMessage;

  FacilityState copyWith({
    final FacilityStatus? status,
    final List<FacilityEntity>? facilities,
    final FacilityEntity? selectedFacility,
    final String? errorMessage,
    final String? successMessage,
    final bool clearMessages = false,
    final bool clearSelectedFacility = false,
  }) => FacilityState(
    status: status ?? this.status,
    facilities: facilities ?? this.facilities,
    selectedFacility: clearSelectedFacility
        ? null
        : selectedFacility ?? this.selectedFacility,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    facilities,
    selectedFacility,
    errorMessage,
    successMessage,
  ];
}
