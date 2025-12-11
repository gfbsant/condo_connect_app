//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';

import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/entities/resident_entity.dart';

part 'resident_model.g.dart';

@JsonSerializable()
class ResidentModel extends ResidentEntity {
  const ResidentModel({
    required super.owner,
    super.id,
    super.userName,
    this.user,
    this.createdAt,
    this.updatedAt,
  }) : super(user: user, createdAt: createdAt, updatedAt: updatedAt);

  factory ResidentModel.fromJson(final Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);

  factory ResidentModel.fromEntity(final ResidentEntity entity) =>
      ResidentModel(id: entity.id, user: entity.user, owner: entity.owner);

  Map<String, dynamic> toJson() => _$ResidentModelToJson(this);

  ResidentEntity toEntity() => ResidentEntity(id: id, user: user, owner: owner);

  @override
  @JsonKey(includeToJson: false, fromJson: _userFromJson)
  final UserEntity? user;

  @override
  @JsonKey(includeToJson: false)
  final DateTime? createdAt;

  @override
  @JsonKey(includeToJson: false)
  final DateTime? updatedAt;

  static UserEntity? _userFromJson(final Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }
    return UserModel.fromJson(json);
  }
}
