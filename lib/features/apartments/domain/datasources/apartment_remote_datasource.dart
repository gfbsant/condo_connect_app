import '../../data/models/apartment_model.dart';

abstract class ApartmentRemoteDataSource {
  Future<ApartmentModel> createApartment(final ApartmentModel apartment);

  Future<ApartmentModel> getApartmentById(final int apartmentId);

  Future<List<ApartmentModel>> getApartments();

  Future<ApartmentModel> updateApartment(
    final int apartmentId,
    final ApartmentModel apartment,
  );

  Future<void> deleteApartment(final String apartmentId);
}
