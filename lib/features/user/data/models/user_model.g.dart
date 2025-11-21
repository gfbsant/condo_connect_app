// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  email: json['email'] as String,
  name: json['name'] as String,
  cpf: json['cpf'] as String,
  birthDate: json['birthDate'] as String,
  password: json['password'] as String,
  phone: json['phone'] as String?,
  id: (json['id'] as num?)?.toInt(),
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'email': instance.email,
  'name': instance.name,
  'cpf': instance.cpf,
  'birthDate': instance.birthDate,
  'password': instance.password,
  'phone': instance.phone,
};
