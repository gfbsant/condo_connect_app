// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeModel _$EmployeeModelFromJson(Map<String, dynamic> json) =>
    EmployeeModel(
      userId: (json['userId'] as num).toInt(),
      condominiumId: (json['condominiumId'] as num).toInt(),
      role: $enumDecode(_$EmployeeRoleEnumMap, json['role']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      id: (json['id'] as num?)?.toInt(),
      description: json['description'] as String?,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$EmployeeModelToJson(EmployeeModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'condominiumId': instance.condominiumId,
      'description': instance.description,
      'role': _$EmployeeRoleEnumMap[instance.role]!,
    };

const _$EmployeeRoleEnumMap = {
  EmployeeRole.admin: 'admin',
  EmployeeRole.manager: 'manager',
  EmployeeRole.colaborator: 'colaborator',
};
