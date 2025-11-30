import 'package:equatable/equatable.dart';

import '../../../residents/domain/entities/resident_entity.dart';

class ApartmentEntity extends Equatable {
  const ApartmentEntity({
    required this.number,
    required this.condominiumId,
    this.id,
    this.floor,
    this.door,
    this.tower,
    this.rented,
    this.active,
    this.residents,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String number;
  final String? floor;
  final String? door;
  final String? tower;
  final bool? rented;
  final bool? active;
  final int condominiumId;
  final List<ResidentEntity>? residents;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    number,
    floor,
    door,
    tower,
    rented,
    active,
    condominiumId,
    residents,
    createdAt,
    updatedAt,
  ];
}
