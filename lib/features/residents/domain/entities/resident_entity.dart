import 'package:equatable/equatable.dart';

import '../../../user/domain/entities/user_entity.dart';

class ResidentEntity extends Equatable {
  const ResidentEntity({
    required this.id,
    required this.owner,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.userName,
  });

  final int? id;
  final bool owner;
  final UserEntity? user;
  final String? userName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [id, owner, user, userName, createdAt, updatedAt];
}
