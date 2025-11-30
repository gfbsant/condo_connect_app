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
import 'package:condo_connect/features/apartments/data/repositories/apartment_repository_impl.dart'
    as _i790;
import 'package:condo_connect/features/apartments/domain/datasources/apartment_remote_datasource.dart'
    as _i308;
import 'package:condo_connect/features/apartments/domain/repositories/apartment_repository.dart'
    as _i270;
import 'package:condo_connect/features/apartments/domain/usecases/approve_apartment_usecase.dart'
    as _i221;
import 'package:condo_connect/features/apartments/domain/usecases/create_apartment_usecase.dart'
    as _i682;
import 'package:condo_connect/features/apartments/domain/usecases/delete_apartment_usecase.dart'
    as _i1013;
import 'package:condo_connect/features/apartments/domain/usecases/get_apartment_by_id_usecase.dart'
    as _i186;
import 'package:condo_connect/features/apartments/domain/usecases/get_apartments_by_condo_usecase.dart'
    as _i18;
import 'package:condo_connect/features/apartments/domain/usecases/update_apartment_usecase.dart'
    as _i442;
import 'package:condo_connect/features/auth/data/datasources/auth_remote_datasource_impl.dart'
    as _i389;
import 'package:condo_connect/features/auth/data/repositories/auth_repository_impl.dart'
    as _i549;
import 'package:condo_connect/features/auth/domain/datasources/auth_remote_datasource.dart'
    as _i509;
import 'package:condo_connect/features/auth/domain/repositories/auth_repository.dart'
    as _i520;
import 'package:condo_connect/features/auth/domain/usecases/confirm_password_reset_usecase.dart'
    as _i231;
import 'package:condo_connect/features/auth/domain/usecases/login_usecase.dart'
    as _i25;
import 'package:condo_connect/features/auth/domain/usecases/logout_usecase.dart'
    as _i719;
import 'package:condo_connect/features/auth/domain/usecases/register_usecase.dart'
    as _i451;
import 'package:condo_connect/features/auth/domain/usecases/request_password_reset_usecase.dart'
    as _i483;
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
import 'package:condo_connect/features/employee/data/repositories/employee_repository_impl.dart'
    as _i824;
import 'package:condo_connect/features/employee/domain/datasources/employee_remote_datasource.dart'
    as _i445;
import 'package:condo_connect/features/employee/domain/repositories/employee_repository.dart'
    as _i384;
import 'package:condo_connect/features/employee/domain/usecases/create_employee_usecase.dart'
    as _i285;
import 'package:condo_connect/features/employee/domain/usecases/delete_employee_usecase.dart'
    as _i519;
import 'package:condo_connect/features/employee/domain/usecases/get_employee_by_id_usecase.dart'
    as _i1071;
import 'package:condo_connect/features/employee/domain/usecases/get_employees_by_condo_usecase.dart'
    as _i265;
import 'package:condo_connect/features/employee/domain/usecases/update_employee_usecase.dart'
    as _i81;
import 'package:condo_connect/features/notice/data/datasources/notice_remote_datasource_impl.dart'
    as _i164;
import 'package:condo_connect/features/notice/data/repositories/notice_repository_impl.dart'
    as _i681;
import 'package:condo_connect/features/notice/domain/datasources/notice_remote_datasource.dart'
    as _i714;
import 'package:condo_connect/features/notice/domain/repositories/notice_repository.dart'
    as _i656;
import 'package:condo_connect/features/notice/domain/usecases/create_notice_usecase.dart'
    as _i20;
import 'package:condo_connect/features/notice/domain/usecases/delete_notice_usecase.dart'
    as _i233;
import 'package:condo_connect/features/notice/domain/usecases/get_notice_by_id_usecase.dart'
    as _i13;
import 'package:condo_connect/features/notice/domain/usecases/get_notices_by_apartment_usecase.dart'
    as _i874;
import 'package:condo_connect/features/notice/domain/usecases/get_notices_by_condo_usecase.dart'
    as _i952;
import 'package:condo_connect/features/notice/domain/usecases/update_notice_usecase.dart'
    as _i85;
import 'package:condo_connect/features/residents/data/datasources/resident_remote_datasource_impl.dart'
    as _i617;
import 'package:condo_connect/features/residents/data/repositories/resident_repository_impl.dart'
    as _i1012;
import 'package:condo_connect/features/residents/domain/datasources/resident_remote_datasource.dart'
    as _i805;
import 'package:condo_connect/features/residents/domain/repositories/resident_repository.dart'
    as _i105;
import 'package:condo_connect/features/residents/domain/usecases/create_resident_usecase.dart'
    as _i87;
import 'package:condo_connect/features/residents/domain/usecases/delete_resident_usecase.dart'
    as _i361;
import 'package:condo_connect/features/residents/domain/usecases/get_resident_by_id_usecase.dart'
    as _i856;
import 'package:condo_connect/features/residents/domain/usecases/get_residents_by_apartment_usecase.dart'
    as _i982;
import 'package:condo_connect/features/residents/domain/usecases/update_resident_usecase.dart'
    as _i718;
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
    gh.factory<_i384.EmployeeRepository>(
      () => _i824.EmployeeRepositoryImpl(gh<_i445.EmployeeRemoteDataSource>()),
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
    gh.factory<_i805.ResidentRemoteDataSource>(
      () => _i617.ResidentRemoteDataSourceImpl(),
    );
    gh.factory<_i714.NoticeRemoteDataSource>(
      () => _i164.NoticeRemoteDataSourceImpl(),
    );
    gh.factory<_i270.ApartmentRepository>(
      () =>
          _i790.ApartmentRepositoryImpl(gh<_i308.ApartmentRemoteDataSource>()),
    );
    gh.factory<_i231.ConfirmPasswordResetUseCase>(
      () => _i231.ConfirmPasswordResetUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i25.LoginUseCase>(
      () => _i25.LoginUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i719.LogoutUseCase>(
      () => _i719.LogoutUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i451.RegisterUseCase>(
      () => _i451.RegisterUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i483.RequestPasswordResetUseCase>(
      () => _i483.RequestPasswordResetUseCase(gh<_i520.AuthRepository>()),
    );
    gh.factory<_i285.CreateEmployeeUseCase>(
      () => _i285.CreateEmployeeUseCase(gh<_i384.EmployeeRepository>()),
    );
    gh.factory<_i519.DeleteEmployeeUseCase>(
      () => _i519.DeleteEmployeeUseCase(gh<_i384.EmployeeRepository>()),
    );
    gh.factory<_i1071.GetEmployeeByIdUseCase>(
      () => _i1071.GetEmployeeByIdUseCase(gh<_i384.EmployeeRepository>()),
    );
    gh.factory<_i265.GetEmployeesByCondoUseCase>(
      () => _i265.GetEmployeesByCondoUseCase(gh<_i384.EmployeeRepository>()),
    );
    gh.factory<_i81.UpdateEmployeeUseCase>(
      () => _i81.UpdateEmployeeUseCase(gh<_i384.EmployeeRepository>()),
    );
    gh.factory<_i105.ResidentRepository>(
      () => _i1012.ResidentRepositoryImpl(gh<_i805.ResidentRemoteDataSource>()),
    );
    gh.factory<_i57.CondoRepository>(
      () => _i864.CondoRepositoryImpl(gh<_i207.CondoRemoteDataSource>()),
    );
<<<<<<< HEAD
=======
    gh.factory<_i87.CreateResidentUseCase>(
      () => _i87.CreateResidentUseCase(gh<_i105.ResidentRepository>()),
    );
    gh.factory<_i361.DeleteResidentUseCase>(
      () => _i361.DeleteResidentUseCase(gh<_i105.ResidentRepository>()),
    );
    gh.factory<_i856.GetResidentByIdUseCase>(
      () => _i856.GetResidentByIdUseCase(gh<_i105.ResidentRepository>()),
    );
    gh.factory<_i982.GetResidentsByApartmentUseCase>(
      () =>
          _i982.GetResidentsByApartmentUseCase(gh<_i105.ResidentRepository>()),
    );
    gh.factory<_i718.UpdateResidentUseCase>(
      () => _i718.UpdateResidentUseCase(gh<_i105.ResidentRepository>()),
    );
>>>>>>> 1855d78 (Implement resident management features)
    gh.factory<_i221.ApproveApartmentUseCase>(
      () => _i221.ApproveApartmentUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i682.CreateApartmentUseCase>(
      () => _i682.CreateApartmentUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i1013.DeleteApartmentUseCase>(
      () => _i1013.DeleteApartmentUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i186.GetApartmentByIdUseCase>(
      () => _i186.GetApartmentByIdUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i18.GetApartmentsByCondoUseCase>(
      () => _i18.GetApartmentsByCondoUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i442.UpdateApartmentUseCase>(
      () => _i442.UpdateApartmentUseCase(gh<_i270.ApartmentRepository>()),
    );
    gh.factory<_i656.NoticeRepository>(
      () => _i681.NoticeRepositoryImpl(gh<_i714.NoticeRemoteDataSource>()),
    );
    gh.factory<_i20.CreateNoticeUseCase>(
      () => _i20.CreateNoticeUseCase(gh<_i656.NoticeRepository>()),
    );
    gh.factory<_i233.DeleteNoticeUseCase>(
      () => _i233.DeleteNoticeUseCase(gh<_i656.NoticeRepository>()),
    );
    gh.factory<_i13.GetNoticeByIdUseCase>(
      () => _i13.GetNoticeByIdUseCase(gh<_i656.NoticeRepository>()),
    );
    gh.factory<_i874.GetNoticesByApartmentUseCase>(
      () => _i874.GetNoticesByApartmentUseCase(gh<_i656.NoticeRepository>()),
    );
    gh.factory<_i952.GetNoticesByCondoUseCase>(
      () => _i952.GetNoticesByCondoUseCase(gh<_i656.NoticeRepository>()),
    );
    gh.factory<_i85.UpdateNoticeUseCase>(
      () => _i85.UpdateNoticeUseCase(gh<_i656.NoticeRepository>()),
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
