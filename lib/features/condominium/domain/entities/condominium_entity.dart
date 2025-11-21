import 'package:equatable/equatable.dart';

class CondominiumEntity extends Equatable {
  const CondominiumEntity({
    required this.name,
    required this.city,
    required this.state,
    required this.neighborhood,
    required this.zipcode,
    required this.address,
    required this.number,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  final int? id;
  final String name;
  final String address;
  final String city;
  final String state;
  final String neighborhood;
  final String zipcode;
  final String number;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    city,
    state,
    neighborhood,
    zipcode,
    number,
    createdAt,
    updatedAt,
  ];
}
