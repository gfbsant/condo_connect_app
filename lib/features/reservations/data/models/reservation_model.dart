//
// ignore_for_file: overridden_fields

import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

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
  }) : super(scheduledDate: scheduledDate);

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

  static String get _scheduledDateFormat => 'yyyy/MM/dd';

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
}
