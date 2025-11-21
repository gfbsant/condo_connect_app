import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/apartment_entity.dart';

part 'apartment_model.g.dart';

@JsonSerializable()
class ApartmentModel extends ApartmentEntity {
  const ApartmentModel({
    required super.number,
    required super.condominiumId,
    required super.createdAt,
    super.id,
    super.floor,
    super.door,
    super.tower,
    super.rented,
    super.active,
    super.updatedAt,
  });

  factory ApartmentModel.fromEntity(final ApartmentEntity entity) =>
      ApartmentModel(
        id: entity.id,
        number: entity.number,
        floor: entity.floor,
        door: entity.door,
        tower: entity.tower,
        rented: entity.rented,
        active: entity.active,
        condominiumId: entity.condominiumId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory ApartmentModel.fromJson(final Map<String, dynamic> json) =>
      _$ApartmentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApartmentModelToJson(this);

  ApartmentEntity toEntity() => ApartmentEntity(
    id: id,
    number: number,
    floor: floor,
    door: door,
    tower: tower,
    rented: rented,
    active: active,
    condominiumId: condominiumId,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
