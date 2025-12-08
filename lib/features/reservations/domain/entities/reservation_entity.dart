import 'package:equatable/equatable.dart';

import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../../facilities/domain/entities/facility_entity.dart';
import '../../../user/domain/entities/user_entity.dart';

class ReservationEntity extends Equatable {
  const ReservationEntity({
    required this.facilityId,
    required this.apartmentId,
    required this.scheduledDate,
    this.id,
    this.creatorId,
    this.creator,
    this.apartment,
    this.facility,
    this.updatedAt,
    this.createdAt,
  });

  final int? id;
  final int facilityId;
  final int apartmentId;
  final int? creatorId;
  final DateTime? scheduledDate;
  final UserEntity? creator;
  final ApartmentEntity? apartment;
  final FacilityEntity? facility;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [];
}
