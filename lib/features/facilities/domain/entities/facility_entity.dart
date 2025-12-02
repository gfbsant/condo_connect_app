import 'package:equatable/equatable.dart';

class FacilityEntity extends Equatable {
  const FacilityEntity({
    required this.name,
    this.id,
    this.description,
    this.tax,
  });

  final int? id;
  final String name;
  final String? description;
  final int? tax;

  @override
  List<Object?> get props => [];
}
