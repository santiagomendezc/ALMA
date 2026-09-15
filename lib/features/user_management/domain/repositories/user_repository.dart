import 'package:dartz/dartz.dart';
import 'package:aplicacion/core/error/failures.dart';
import 'package:aplicacion/features/user_management/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure, User>> createUser(String nickname);
  Future<Either<Failure, void>> deleteUser(String id);
}
