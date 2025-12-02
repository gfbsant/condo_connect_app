import '../../data/models/facility_model.dart';

abstract class FacilityRemoteDataSource {
  Future<FacilityModel> createFacility(
    final int condominiumId,
    final FacilityModel facility,
  );

  Future<List<FacilityModel>> getFacilitiesByCondo(final int condominiumId);

  Future<FacilityModel> getFacilityById(final int facilityId);

  Future<FacilityModel> updateFacility(
    final int facilityId,
    final FacilityModel facility,
  );

  Future<void> deleteFacility(final int facilityId);
}
