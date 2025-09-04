enum UserRole {
  // Equivalente a 'morador'
  resident('resident'),

  // Equivalente a 'síndico'
  manager('manager'),

  // Equivalente a 'porteiro'
  doorman('doorman');

  const UserRole(this.value);

  final String value;

  static UserRole fromString(String value) {
    return UserRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => UserRole.resident,
    );
  }

  @override
  String toString() => value;
}
