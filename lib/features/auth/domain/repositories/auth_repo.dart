// features/auth/domain/repositories/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';

import '../entities/apply_entity.dart';

abstract interface class AuthRepo {
  Future<Either<ApiException, LoginResponse>> login(
      LoginRequset loginRequset, bool rememberMe);

  cacheRememberMe(bool rememberMe);

    //-----------------------------Apply as Driver-----------------------------------
  Future<Either<Exception, bool>> apply(ApplyEntity entity);
}
