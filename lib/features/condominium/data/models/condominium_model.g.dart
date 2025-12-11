// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumModel _$CondominiumModelFromJson(Map<String, dynamic> json) =>
    CondominiumModel(
      name: json['name'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      neighborhood: json['neighborhood'] as String,
      zipcode: json['zipcode'] as String,
      address: json['address'] as String,
      number: json['number'] as String,
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CondominiumModelToJson(CondominiumModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'state': instance.state,
      'neighborhood': instance.neighborhood,
      'zipcode': instance.zipcode,
      'number': instance.number,
    };
