import '../../core/services/base_http_service.dart';
import '../interfaces/condo_service_interface.dart';
import '../interfaces/http_client_interface.dart';
import '../models/api_response.dart';
import '../models/condo_model.dart';

class CondoService extends BaseHttpService implements CondoServiceInterface {
  CondoService({
    required super.baseUrl,
    super.httpClient,
  });

  String get _condominiaPath => '/condominia';

  @override
  Future<ApiResponse<Condo>> createCondo(final Condo condo) =>
      makeRequest<Condo>(
        RequestType.POST,
        _condominiaPath,
        jsonBody: condo.toJson,
        headers: jsonContentHeader,
        fromJson: (final json) => Condo.fromJson(json as Map<String, dynamic>),
      );

  @override
  Future<ApiResponse<Condo>> updateCondo(final int id, final Condo condo) =>
      makeRequest<Condo>(
        RequestType.PUT,
        '$_condominiaPath/$id',
        jsonBody: condo.toJson,
        headers: jsonContentHeader,
        fromJson: (final json) => Condo.fromJson(json as Map<String, dynamic>),
      );

  @override
  Future<ApiResponse<List<Condo>>> getAllCondos() => makeRequest(
        RequestType.GET,
        '/condiminiums',
        headers: jsonContentHeader,
        fromJson: (final json) {
          final list = json as List<dynamic>;
          return list
              .map(
                (final item) => Condo.fromJson(item as Map<String, dynamic>),
              )
              .toList();
        },
      );

  @override
  Future<ApiResponse<Condo>> getCondoById(final int id) => makeRequest(
        RequestType.GET,
        '$_condominiaPath/$id',
        headers: jsonContentHeader,
        fromJson: (final json) => Condo.fromJson(json as Map<String, dynamic>),
      );

  @override
  Future<ApiResponse<void>> deleteCondo(final int id) => makeRequest(
        RequestType.DELETE,
        '$_condominiaPath/$id',
        headers: jsonContentHeader,
      );
}
