import 'package:json_annotation/json_annotation.dart';

import '../domain/entities/resident_entity.dart';

part 'resident_model.g.dart';

@JsonSerializable()
class ResidentModel extends ResidentEntity {
  const ResidentModel({
    required super.id,
    required super.userName,
    required super.owner,
  });

  factory ResidentModel.fromJson(final Map<String, dynamic> json) =>
      _$ResidentModelFromJson(json);

  factory ResidentModel.fromEntity(final ResidentEntity entity) =>
      ResidentModel(
        id: entity.id,
        userName: entity.userName,
        owner: entity.owner,
      );

  Map<String, dynamic> toJson() => _$ResidentModelToJson(this);

  ResidentEntity toEntity() =>
      ResidentEntity(id: id, userName: userName, owner: owner);
}
