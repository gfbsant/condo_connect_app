// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacilityModel _$FacilityModelFromJson(Map<String, dynamic> json) =>
    FacilityModel(
      name: json['name'] as String,
      schedulable: json['schedulable'] as bool,
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      tax: (json['tax'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FacilityModelToJson(FacilityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'schedulable': instance.schedulable,
      'tax': instance.tax,
    };
