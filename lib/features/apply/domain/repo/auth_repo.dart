// features/apply/domain/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';

abstract class AuthRepo {
  //-----------------------------Apply as Driver-----------------------------------
  Future<Either<Exception, bool>> apply(ApplyEntity entity);
}
