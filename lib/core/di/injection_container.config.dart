// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:condo_connect/core/clients/http_client.dart' as _i580;
import 'package:condo_connect/core/clients/http_client_impl.dart' as _i593;
import 'package:condo_connect/core/services/storage/secure_storage_service.dart'
    as _i614;
import 'package:condo_connect/core/services/storage/secure_storage_service_impl.dart'
    as _i988;
import 'package:condo_connect/features/apartments/data/datasources/apartment_remote_datasource_impl.dart'
    as _i94;
import 'package:condo_connect/features/apartments/domain/datasources/apartment_remote_datasource.dart'
    as _i308;
import 'package:condo_connect/features/auth/data/datasources/auth_remote_datasource_impl.dart'
    as _i389;
import 'package:condo_connect/features/auth/data/repositories/auth_repository_impl.dart'
    as _i549;
import 'package:condo_connect/features/auth/domain/datasources/auth_remote_datasource.dart'
    as _i509;
import 'package:condo_connect/features/auth/domain/repositories/auth_repository.dart'
    as _i520;
import 'package:condo_connect/features/auth/domain/usecases/login_usecase.dart'
    as _i25;
import 'package:condo_connect/features/auth/domain/usecases/logout_usecase.dart'
    as _i719;
import 'package:condo_connect/features/condominium/data/datasources/condo_remote_datasource_impl.dart'
    as _i713;
import 'package:condo_connect/features/condominium/data/repositories/condo_repository_impl.dart'
    as _i864;
import 'package:condo_connect/features/condominium/domain/datasources/condo_remote_datasource.dart'
    as _i207;
import 'package:condo_connect/features/condominium/domain/repositories/condo_repository.dart'
    as _i57;
import 'package:condo_connect/features/condominium/domain/usecases/create_condo_usecase.dart'
    as _i164;
import 'package:condo_connect/features/condominium/domain/usecases/delete_condo_usecase.dart'
    as _i992;
import 'package:condo_connect/features/condominium/domain/usecases/get_condo_by_id_usecase.dart'
    as _i123;
import 'package:condo_connect/features/condominium/domain/usecases/search_condos_usecase.dart'
    as _i309;
import 'package:condo_connect/features/condominium/domain/usecases/update_condo_usecase.dart'
    as _i175;
import 'package:condo_connect/features/employee/data/datasources/employee_remote_datasource_impl.dart'
    as _i584;
import 'package:condo_connect/features/employee/domain/datasources/employee_remote_datasource.dart'
    as _i445;
import 'package:condo_connect/features/notice/data/datasources/notice_remote_datasource_impl.dart'
    as _i164;
import 'package:condo_connect/features/notice/data/repositories/notice_repository_impl.dart'
    as _i681;
import 'package:condo_connect/features/notice/domain/datasources/notice_remote_datasource.dart'
    as _i714;
import 'package:condo_connect/features/notice/domain/repositories/notice_repository.dart'
    as _i656;
import 'package:condo_connect/features/user/data/datasources/user_remote_datasource_impl.dart'
    as _i932;
import 'package:condo_connect/features/user/domain/datasources/user_remote_datasource.dart'
    as _i672;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i207.CondoRemoteDataSource>(
      () => _i713.CondoRemoteDataSourceImpl(),
    );
    gh.factory<_i308.ApartmentRemoteDataSource>(
      () => _i94.ApartmentRemoteDataSourceImpl(),
    );
    gh.factory<_i445.EmployeeRemoteDataSource>(
      () => _i584.EmployeeRemoteDataSourceImpl(),
    );
    gh.factory<_i672.UserRemoteDataSource>(
      () => _i932.UserRemoteDataSourceImpl(),
    );
    gh.factory<_i509.AuthRemoteDataSource>(
      () => _i389.AuthRemoteDataSourceImpl(),
    );
    gh.factory<_i580.HttpCaller>(
      () => _i593.HttpCallerImpl(timeoutSeconds: gh<int>()),
    );
    gh.factory<_i614.SecureStorageService>(
      () => _i988.SecureStorageServiceImpl(),
    );
    gh.factory<_i520.AuthRepository>(
      () => _i549.AuthRepositoryImpl(gh<_i509.AuthRemoteDataSource>()),
    );
    gh.factory<_i714.NoticeRemoteDataSource>(
      () => _i164.NoticeRemoteDataSourceImpl(),
    );
    gh.factory<_i25.LoginUseCase>(
      () => _i25.LoginUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i719.LogoutUseCase>(
      () => _i719.LogoutUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i57.CondoRepository>(
      () => _i864.CondoRepositoryImpl(gh<_i207.CondoRemoteDataSource>()),
    );
    gh.factory<_i656.NoticeRepository>(
      () => _i681.NoticeRepositoryImpl(gh<_i714.NoticeRemoteDataSource>()),
    );
    gh.factory<_i164.CreateCondoUseCase>(
      () => _i164.CreateCondoUseCase(gh<_i57.CondoRepository>()),
    );
    gh.factory<_i992.DeleteCondoUseCase>(
      () => _i992.DeleteCondoUseCase(gh<_i57.CondoRepository>()),
    );
    gh.factory<_i123.GetCondoByIdUseCase>(
      () => _i123.GetCondoByIdUseCase(gh<_i57.CondoRepository>()),
    );
    gh.factory<_i309.SearchCondosUseCase>(
      () => _i309.SearchCondosUseCase(gh<_i57.CondoRepository>()),
    );
    gh.factory<_i175.UpdateCondoUseCase>(
      () => _i175.UpdateCondoUseCase(gh<_i57.CondoRepository>()),
    );
    return this;
  }
}
