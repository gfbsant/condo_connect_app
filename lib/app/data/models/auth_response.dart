import 'user_model.dart';

class AuthResponse {
  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
    required this.expiresAt,
  });

  factory AuthResponse.fromJson(final Map<String, dynamic> json) =>
      AuthResponse(
        token: json['token'],
        refreshToken: json['refresh_token'],
        user: User.fromJson(json['user']),
        expiresAt: DateTime.parse(json['expires_at']),
      );
  final String token;
  final String refreshToken;
  final User user;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'token': token,
        'refresh_token': refreshToken,
        'user': user.toJson(),
        'expires_at': expiresAt.toIso8601String(),
      };

  AuthResponse copyWith({
    final String? token,
    final String? refreshToken,
    final User? user,
    final DateTime? expiresAt,
  }) =>
      AuthResponse(
        token: token ?? this.token,
        refreshToken: refreshToken ?? this.refreshToken,
        user: user ?? this.user,
        expiresAt: expiresAt ?? this.expiresAt,
      );

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) return true;
    return other is AuthResponse &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.user == user &&
        other.expiresAt == expiresAt;
  }

  @override
  int get hashCode =>
      token.hashCode ^
      refreshToken.hashCode ^
      user.hashCode ^
      expiresAt.hashCode;
}
