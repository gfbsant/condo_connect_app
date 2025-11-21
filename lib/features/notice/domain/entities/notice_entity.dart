import 'package:equatable/equatable.dart';

import '../enums/notice_status.dart';
import '../enums/notice_type.dart';

class NoticeEntity extends Equatable {
  const NoticeEntity({
    required this.title,
    required this.noticeType,
    required this.status,
    required this.apartmentId,
    required this.creatorId,
    required this.createdAt,
    this.id,
    this.description,
    this.typeInfo,
    this.updatedAt,
  });

  final int? id;
  final String title;
  final String? description;
  final NoticeType noticeType;
  final NoticeStatus status;
  final String? typeInfo;
  final int apartmentId;
  final int creatorId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    apartmentId,
    creatorId,
    title,
    description,
    noticeType,
    status,
    createdAt,
    updatedAt,
  ];
}
