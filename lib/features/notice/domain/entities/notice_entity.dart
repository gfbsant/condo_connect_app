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
    this.createdAt,
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

  bool get canBeEdited => status == NoticeStatus.pending;

  bool get isResolved => status == NoticeStatus.resolved;

  bool get isBlocked => status == NoticeStatus.blocked;

  String get statusDisplay {
    switch (status) {
      case NoticeStatus.pending:
        return 'Pendente';
      case NoticeStatus.acknowledged:
        return 'Reconhecido';
      case NoticeStatus.resolved:
        return 'Resolvido';
      case NoticeStatus.blocked:
        return 'Bloqueado';
    }
  }

  String get typeDisplayName {
    switch (noticeType) {
      case NoticeType.delivery:
        return 'Entrega';
      case NoticeType.visitor:
        return 'Visitante';
      case NoticeType.maintenance:
        return 'Manutenção';
      case NoticeType.communication:
        return 'Comunicação';
    }
  }

  NoticeEntity copyWith({
    final int? id,
    final String? title,
    final String? description,
    final NoticeType? noticeType,
    final NoticeStatus? status,
    final String? typeInfo,
    final int? apartmentId,
    final int? creatorId,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) => NoticeEntity(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    noticeType: noticeType ?? this.noticeType,
    status: status ?? this.status,
    typeInfo: typeInfo ?? this.typeInfo,
    apartmentId: apartmentId ?? this.apartmentId,
    creatorId: creatorId ?? this.creatorId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    noticeType,
    status,
    apartmentId,
    creatorId,
    createdAt,
    updatedAt,
  ];
}
