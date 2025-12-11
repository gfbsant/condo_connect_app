import '../../data/models/apartment_model.dart';

abstract class ApartmentRemoteDataSource {
  Future<ApartmentModel> createApartment(
    final int condominiumId,
    final ApartmentModel apartment,
  );

  Future<List<ApartmentModel>> getApartmentsByCondo(
    final int condominiumId,
    final Map<String, String>? query,
  );

  Future<ApartmentModel> getApartmentById(final int apartmentId);

  Future<ApartmentModel> updateApartment(
    final int apartmentId,
    final ApartmentModel apartment,
  );

  Future<ApartmentModel> approveApartment(final int apartmentId);

  Future<void> deleteApartment(final int apartmentId);
}
