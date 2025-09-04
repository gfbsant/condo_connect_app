import 'package:condo_connect/models/user_model.dart';

class AuthResponse {
  final String token;
  final String refreshToken;
  final UserModel user;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      refreshToken: json['refresh_token'],
      user: UserModel.fromJson(json['user']),
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  AuthResponse copyWith({
    String? token,
    String? refreshToken,
    UserModel? user,
    DateTime? expiresAt,
  }) {
    return AuthResponse(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.user == user &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode {
    return token.hashCode ^
        refreshToken.hashCode ^
        user.hashCode ^
        expiresAt.hashCode;
  }
}
