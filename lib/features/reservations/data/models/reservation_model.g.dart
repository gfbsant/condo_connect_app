// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationModel _$ReservationModelFromJson(Map<String, dynamic> json) =>
    ReservationModel(
      facilityId: (json['facilityId'] as num).toInt(),
      apartmentId: (json['apartmentId'] as num).toInt(),
      scheduledDate: ReservationModel._scheduledDateFromJson(
        json['scheduledDate'] as String?,
      ),
      id: (json['id'] as num?)?.toInt(),
      creatorId: (json['creatorId'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ReservationModelToJson(ReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'facilityId': instance.facilityId,
      'apartmentId': instance.apartmentId,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'scheduledDate': ReservationModel._scheduledDateToJson(
        instance.scheduledDate,
      ),
    };
