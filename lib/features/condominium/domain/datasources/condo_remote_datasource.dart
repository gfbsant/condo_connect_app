import '../../data/models/condominium_model.dart';

abstract class CondoRemoteDataSource {
  Future<CondominiumModel> createCondominium(final CondominiumModel condo);

  Future<CondominiumModel> getCondominiumById(final int id);

  Future<List<CondominiumModel>> searchCondos({final String? query});

  Future<CondominiumModel> updateCondominium(
    final int id,
    final CondominiumModel condo,
  );

  Future<void> deleteCondominium(final int id);
}
