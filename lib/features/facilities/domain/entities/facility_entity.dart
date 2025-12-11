import 'package:equatable/equatable.dart';

class FacilityEntity extends Equatable {
  const FacilityEntity({
    required this.name,
    required this.schedulable,
    this.id,
    this.description,
    this.tax,
  });

  final int? id;
  final String name;
  final String? description;
  final bool schedulable;
  final int? tax;

  @override
  List<Object?> get props => [id, name, description, schedulable, tax];
}
