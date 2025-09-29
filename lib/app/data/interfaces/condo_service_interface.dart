import '../models/api_response.dart';
import '../models/condo_model.dart';

abstract class CondoServiceInterface {
  Future<ApiResponse<Condo>> createCondo(final Condo condo);

  Future<ApiResponse<Condo>> updateCondo(
    final int id,
    final Condo condo,
  );

  Future<ApiResponse<List<Condo>>> getAllCondos();

  Future<ApiResponse<Condo>> getCondoById(final int id);

  Future<ApiResponse<void>> deleteCondo(final int id);
}
