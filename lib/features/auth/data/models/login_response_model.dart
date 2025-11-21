import 'package:json_annotation/json_annotation.dart';

import '../../../user/data/models/user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  const LoginResponseModel({required this.status, required this.user});

  factory LoginResponseModel.fromJson(final Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  final int status;
  final UserModel user;

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
