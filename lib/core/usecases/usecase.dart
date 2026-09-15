import 'package:equatable/equatable.dart';
import 'package:aplicacion/core/error/failures.dart';
import 'package:dartz/dartz.dart';


abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
