import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/condominium_entity.dart';

part 'condominium_model.g.dart';

@JsonSerializable()
class CondominiumModel extends CondominiumEntity {
  const CondominiumModel({
    required super.name,
    required super.city,
    required super.state,
    required super.neighborhood,
    required super.zipcode,
    required super.address,
    required super.number,
    super.id,
    super.createdAt,
    super.updatedAt,
  });

  factory CondominiumModel.fromEntity(final CondominiumEntity entity) =>
      CondominiumModel(
        id: entity.id,
        name: entity.name,
        city: entity.city,
        state: entity.state,
        neighborhood: entity.neighborhood,
        zipcode: entity.zipcode,
        address: entity.address,
        number: entity.number,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory CondominiumModel.fromJson(final Map<String, dynamic> json) =>
      _$CondominiumModelFromJson(json);

  Map<String, dynamic> get toJson => _$CondominiumModelToJson(this);

  CondominiumModel copyWith({
    final int? id,
    final String? name,
    final String? city,
    final String? state,
    final String? neighborhood,
    final String? zipcode,
    final String? address,
    final String? number,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) => CondominiumModel(
    id: id ?? this.id,
    name: name ?? this.name,
    city: city ?? this.city,
    state: state ?? this.state,
    neighborhood: neighborhood ?? this.neighborhood,
    zipcode: zipcode ?? this.zipcode,
    address: address ?? this.address,
    number: number ?? this.number,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  CondominiumEntity toEntity() => CondominiumEntity(
    id: id,
    name: name,
    city: city,
    state: state,
    neighborhood: neighborhood,
    zipcode: zipcode,
    address: address,
    number: number,
  );
}
