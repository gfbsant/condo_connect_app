import 'package:equatable/equatable.dart';

import '../../domain/entities/apartment_entity.dart';

enum ApartmentStatus { initial, loading, searching, approving, success, error }

class ApartmentState extends Equatable {
  const ApartmentState({
    required this.status,
    this.apartments = const [],
    this.selectedApartment,
    this.errorMessage,
    this.successMessage,
  });

  const ApartmentState.initial()
    : status = .initial,
      apartments = const [],
      selectedApartment = null,
      errorMessage = null,
      successMessage = null;

  final ApartmentStatus status;
  final List<ApartmentEntity> apartments;
  final ApartmentEntity? selectedApartment;
  final String? errorMessage;
  final String? successMessage;

  ApartmentState copyWith({
    final ApartmentStatus? status,
    final List<ApartmentEntity>? apartments,
    final ApartmentEntity? selectedApartment,
    final String? errorMessage,
    final String? successMessage,
    final bool clearMessages = false,
    final bool clearSelectedApartment = false,
  }) => ApartmentState(
    status: status ?? this.status,
    apartments: apartments ?? this.apartments,
    selectedApartment: clearSelectedApartment
        ? null
        : selectedApartment ?? this.selectedApartment,
    errorMessage: clearMessages ? null : errorMessage ?? this.errorMessage,
    successMessage: clearMessages
        ? null
        : successMessage ?? this.successMessage,
  );

  @override
  List<Object?> get props => [
    status,
    apartments,
    selectedApartment,
    errorMessage,
    successMessage,
  ];
}
