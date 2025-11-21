import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/notice_entity.dart';
import '../../domain/enums/notice_status.dart';
import '../../domain/enums/notice_type.dart';

part 'notice_model.g.dart';

@JsonSerializable()
class NoticeModel extends NoticeEntity {
  const NoticeModel({
    required super.apartmentId,
    required super.creatorId,
    required super.title,
    required super.noticeType,
    required super.status,
    super.id,
    super.description,
    super.typeInfo,
    super.createdAt,
    super.updatedAt,
  });

  factory NoticeModel.fromEntity(final NoticeEntity entity) => NoticeModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    noticeType: entity.noticeType,
    status: entity.status,
    typeInfo: entity.typeInfo,
    creatorId: entity.creatorId,
    apartmentId: entity.apartmentId,
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
  );

  factory NoticeModel.fromJson(final Map<String, dynamic> json) =>
      _$NoticeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoticeModelToJson(this);

  NoticeEntity toEntity() => NoticeEntity(
    id: id,
    title: title,
    description: description,
    noticeType: noticeType,
    status: status,
    typeInfo: typeInfo,
    creatorId: creatorId,
    apartmentId: apartmentId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
