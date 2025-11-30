// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    ResidentModel(
      id: (json['id'] as num).toInt(),
      userName: json['userName'] as String,
      owner: json['owner'] as bool,
    );

Map<String, dynamic> _$ResidentModelToJson(ResidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'owner': instance.owner,
    };
