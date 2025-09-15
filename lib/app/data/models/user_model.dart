import 'package:condo_connect/app/data/models/user_role.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String? phone;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final UserRole role;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    this.phone,
    required this.createdAt,
    this.updatedAt,
    this.isActive = true,
    this.role = UserRole.resident,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      phone: json['phone'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      role: UserRole.fromString(json['role'] as String? ?? 'resident'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'cpf': cpf,
      'phone': phone,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'is_active': isActive,
      'role': role.value,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? cpf,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    UserRole? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      role: role ?? this.role,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.cpf == cpf &&
        other.phone == phone &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isActive == isActive &&
        other.role == role;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        cpf.hashCode ^
        phone.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isActive.hashCode ^
        role.hashCode;
  }

  @override
  String toString() {
    return 'UserModel (id: $id, name: $name, email: $email, cpf: $cpf, : $role)';
  }
}
