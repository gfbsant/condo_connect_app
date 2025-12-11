//
// ignore_for_file: overridden_fields

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../apartments/data/models/apartment_model.dart';
import '../../../apartments/domain/entities/apartment_entity.dart';
import '../../../facilities/data/models/facility_model.dart';
import '../../../facilities/domain/entities/facility_entity.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/reservation_entity.dart';

part 'reservation_model.g.dart';

@JsonSerializable()
class ReservationModel extends ReservationEntity {
  const ReservationModel({
    required super.facilityId,
    required super.apartmentId,
    required this.scheduledDate,
    super.id,
    super.creatorId,
    super.createdAt,
    super.updatedAt,
    this.apartment,
    this.creator,
    this.facility,
  }) : super(
         scheduledDate: scheduledDate,
         facility: facility,
         apartment: apartment,
         creator: creator,
       );

  factory ReservationModel.fromJson(final Map<String, dynamic> json) =>
      _$ReservationModelFromJson(json);

  factory ReservationModel.fromEntity(final ReservationEntity entity) =>
      ReservationModel(
        id: entity.id,
        facilityId: entity.facilityId,
        apartmentId: entity.apartmentId,
        creatorId: entity.creatorId,
        scheduledDate: entity.scheduledDate,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  Map<String, dynamic> toJson() => _$ReservationModelToJson(this);

  @JsonKey(fromJson: _scheduledDateFromJson, toJson: _scheduledDateToJson)
  @override
  final DateTime? scheduledDate;

  static String get _scheduledDateFormat => 'yyyy-MM-dd';

  static DateTime? _scheduledDateFromJson(final String? date) {
    if (date == null || date.isEmpty) {
      return null;
    }
    return DateFormat(_scheduledDateFormat).parse(date);
  }

  static String? _scheduledDateToJson(final DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateFormat(_scheduledDateFormat).format(date);
  }

  @override
  @JsonKey(includeToJson: false, fromJson: _apartmentFromJson)
  final ApartmentEntity? apartment;

  static ApartmentEntity? _apartmentFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return ApartmentModel.fromJson(json);
  }

  @override
  @JsonKey(includeToJson: false, fromJson: _facilityFromJson)
  final FacilityEntity? facility;

  static FacilityEntity? _facilityFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return FacilityModel.fromJson(json);
  }

  @override
  @JsonKey(includeToJson: false, fromJson: _creatorFromJson)
  final UserEntity? creator;

  static UserEntity? _creatorFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UserModel.fromJson(json);
  }
}
