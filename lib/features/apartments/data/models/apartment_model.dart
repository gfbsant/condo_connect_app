//
// ignore_for_file: overridden_fields

import 'package:json_annotation/json_annotation.dart';
import '../../../residents/data/models/resident_model.dart';
import '../../../residents/domain/entities/resident_entity.dart';
import '../../domain/entities/apartment_entity.dart';

part 'apartment_model.g.dart';

@JsonSerializable()
class ApartmentModel extends ApartmentEntity {
  const ApartmentModel({
    required super.number,
    super.id,
    super.floor,
    super.door,
    super.tower,
    super.rented,
    super.active,
    this.residents,
    super.createdAt,
    super.updatedAt,
  }) : super(residents: residents);

  factory ApartmentModel.fromEntity(final ApartmentEntity entity) =>
      ApartmentModel(
        id: entity.id,
        number: entity.number,
        floor: entity.floor,
        door: entity.door,
        tower: entity.tower,
        rented: entity.rented,
        active: entity.active,
        residents: entity.residents,
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
    residents: residents,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  @JsonKey(fromJson: _residentsFromJson, toJson: _residentsToJson)
  @override
  final List<ResidentEntity>? residents;

  static List<ResidentEntity>? _residentsFromJson(final List<dynamic>? json) =>
      json
          ?.map((final e) => ResidentModel.fromJson(e as Map<String, dynamic>))
          .toList();

  static List<dynamic>? _residentsToJson(
    final List<ResidentEntity>? residents,
  ) => residents
      ?.map((final e) => ResidentModel.fromEntity(e).toJson())
      .toList();
}
