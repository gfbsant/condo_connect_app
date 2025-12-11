enum PermissionType {
  readCondominium('readCondominium'),
  showUser('showUser'),
  createCondominium('createCondominium'),
  createApartment('createApartment'),
  manageCondominium('manageCondominium'),
  readNotices('readNotices'),
  readEmployees('readEmployees'),
  readApartment('readApartment'),
  approveApartment('approveApartment'),
  updateApartment('updateApartment'),
  destroyApartment('destroyApartment'),
  createEmployee('createEmployee'),
  readEmployee('readEmployee'),
  updateEmployee('updateEmployee'),
  destroyEmployee('destroyEmployee'),
  createNotice('createNotice'),
  readNotice('readNotice'),
  updateNotice('updateNotice'),
  destroyNotice('destroyNotice'),
  createResident('createResident'),
  readResident('readResident'),
  updateResident('updateResident'),
  destroyResident('destroyResident'),
  createReservation('createReservation'),
  readReservation('readReservation'),
  destroyReservation('destroyReservation');

  const PermissionType(this.value);

  final String value;

  static PermissionType? fromString(final String? value) {
    if (value == null) {
      return null;
    }
    return PermissionType.values.firstWhere((final e) => e.value == value);
  }

  static List<PermissionType> fromStringList(final List<String> values) =>
      values.map(fromString).whereType<PermissionType>().toList();
}
