import 'package:equatable/equatable.dart';

class ResidentEntity extends Equatable {
  const ResidentEntity({
    required this.id,
    required this.userName,
    required this.owner,
  });

  final int id;
  final String userName;
  final bool owner;

  @override
  List<Object?> get props => [id, userName, owner];
}
