// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoticeModel _$NoticeModelFromJson(Map<String, dynamic> json) => NoticeModel(
  apartmentId: (json['apartmentId'] as num).toInt(),
  creatorId: (json['creatorId'] as num).toInt(),
  title: json['title'] as String,
  noticeType: $enumDecode(_$NoticeTypeEnumMap, json['noticeType']),
  status: $enumDecode(_$NoticeStatusEnumMap, json['status']),
  id: (json['id'] as num?)?.toInt(),
  description: json['description'] as String?,
  typeInfo: json['typeInfo'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$NoticeModelToJson(NoticeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'noticeType': _$NoticeTypeEnumMap[instance.noticeType]!,
      'status': _$NoticeStatusEnumMap[instance.status]!,
      'typeInfo': instance.typeInfo,
      'apartmentId': instance.apartmentId,
      'creatorId': instance.creatorId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

const _$NoticeTypeEnumMap = {
  NoticeType.delivery: 'delivery',
  NoticeType.visitor: 'visitor',
  NoticeType.maintenance: 'maintenance',
  NoticeType.communication: 'communication',
};

const _$NoticeStatusEnumMap = {
  NoticeStatus.pending: 'pending',
  NoticeStatus.acknowledged: 'acknowledged',
  NoticeStatus.resolved: 'resolved',
  NoticeStatus.blocked: 'blocked',
};
