import 'package:aplicacion/core/error/failures.dart';
import 'package:aplicacion/features/user_management/data/datasources/user_local_data_source.dart';
import 'package:aplicacion/features/user_management/data/models/user_model.dart';
import 'package:aplicacion/features/user_management/domain/entities/user.dart';
import 'package:aplicacion/features/user_management/domain/repositories/user_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:uuid/uuid.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final users = await localDataSource.getUsers();
      return Right(users);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, User>> createUser(String nickname) async {
    try {
      final users = await localDataSource.getUsers();
      final newUser = UserModel(id: const Uuid().v4(), nickname: nickname);
      users.add(newUser);
      await localDataSource.cacheUsers(users);
      return Right(newUser);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteUser(String id) async {
    try {
       final users = await localDataSource.getUsers();
       users.removeWhere((user) => user.id == id);
       await localDataSource.cacheUsers(users);
       return Right(null);
    } catch(e) {
       return Left(CacheFailure());
    }
  }
}
