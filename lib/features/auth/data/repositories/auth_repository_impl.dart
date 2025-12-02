import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../shared/errors/failures.dart';
import '../../../../shared/exceptions/api_exception.dart';
import '../../../user/data/models/user_model.dart';
import '../../../user/domain/entities/user_entity.dart';
import '../../domain/datasources/auth_remote_datasource.dart';
import '../../domain/repositories/auth_repository.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this.remoteDataSource);

  final AuthRemoteDataSource remoteDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required final String email,
    required final String password,
  }) async {
    try {
      final UserModel result = await remoteDataSource.login(email, password);

      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro no login: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro no logout: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required final UserEntity user,
  }) async {
    try {
      final UserEntity response = await remoteDataSource.register(
        user: UserModel.fromEntity(user),
      );

      return Right(response);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro no registro: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required final String token,
    required final String newPassword,
  }) async {
    try {
      await remoteDataSource.resetPassword(token, newPassword);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao confirmar senha: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(final String email) async {
    try {
      await remoteDataSource.requestPasswordReset(email);
      return const Right(null);
    } on ApiException catch (e) {
      return Left(ServerFailure(message: e.message));
    } on Exception catch (e) {
      return Left(ServerFailure(message: 'Erro ao mudar senha: $e'));
    }
  }
}
