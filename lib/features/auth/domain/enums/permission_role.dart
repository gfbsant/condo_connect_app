enum PermissionRole {
  admin('admin'),
  collaborator('collaborator'),
  owner('owner'),
  resident('resident');

  const PermissionRole(this.value);

  final String value;

  //
  // ignore: prefer_final_parameters
  static PermissionRole? fromString(String? value) {
    if (value == null) {
      return null;
    }
    return PermissionRole.values.firstWhere((final e) => e.value == value);
  }
}
