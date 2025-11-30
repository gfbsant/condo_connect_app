// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apartment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApartmentModel _$ApartmentModelFromJson(Map<String, dynamic> json) =>
    ApartmentModel(
      number: json['number'] as String,
      condominiumId: (json['condominiumId'] as num).toInt(),
      id: (json['id'] as num?)?.toInt(),
      floor: json['floor'] as String?,
      door: json['door'] as String?,
      tower: json['tower'] as String?,
      rented: json['rented'] as bool?,
      active: json['active'] as bool?,
      residents: ApartmentModel._residentsFromJson(json['residents'] as List?),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ApartmentModelToJson(ApartmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'floor': instance.floor,
      'door': instance.door,
      'tower': instance.tower,
      'rented': instance.rented,
      'active': instance.active,
      'condominiumId': instance.condominiumId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'residents': ApartmentModel._residentsToJson(instance.residents),
    };
