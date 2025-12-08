import '../../data/models/reservation_model.dart';

abstract class ReservationRemoteDataSource {
  Future<ReservationModel> createReservation(
    final int facilityId,
    final ReservationModel reservation,
  );

  Future<List<ReservationModel>> getReservationsByFacility(
    final int facilityId,
  );

  Future<List<ReservationModel>> getReservationsByApartment(
    final int apartmentId,
  );

  Future<void> deleteReservation(final int reservationId);
}
