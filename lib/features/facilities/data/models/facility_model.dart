import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/facility_entity.dart';

part 'facility_model.g.dart';

@JsonSerializable()
class FacilityModel extends FacilityEntity {
  const FacilityModel({
    required super.name,
    super.id,
    super.description,
    super.tax,
  });

  factory FacilityModel.froJson(final Map<String, dynamic> json) =>
      _$FacilityModelFromJson(json);

  factory FacilityModel.fromEntity(final FacilityEntity entity) =>
      FacilityModel(
        id: entity.id,
        name: entity.name,
        description: entity.description,
        tax: entity.tax,
      );

  Map<String, dynamic> toJson() => _$FacilityModelToJson(this);

  FacilityEntity toEntity() =>
      FacilityEntity(id: id, name: name, description: description, tax: tax);
}
