import '../../data/models/resident_model.dart';

abstract class ResidentRemoteDataSource {
  Future<ResidentModel> createResident(
    final int apartmentId,
    final String email,
  );

  Future<List<ResidentModel>> getResidentsByApartment(final int apartmentId);

  Future<ResidentModel> getResidentById(final int residentId);

  Future<ResidentModel> updateResident(
    final int apartmentId,
    final int residentId,
    final ResidentModel resident,
  );

  Future<void> deleteResident(final int apartmentId, final int residentId);
}
