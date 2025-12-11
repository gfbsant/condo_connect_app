// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    ResidentModel(
      owner: json['owner'] as bool,
      id: (json['id'] as num?)?.toInt(),
      userName: json['userName'] as String?,
      user: ResidentModel._userFromJson(json['user'] as Map<String, dynamic>?),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ResidentModelToJson(ResidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'userName': instance.userName,
    };
