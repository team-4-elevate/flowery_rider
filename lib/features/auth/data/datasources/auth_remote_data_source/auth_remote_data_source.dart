// features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/models/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';

import '../../models/apply/apply_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequset loginRequset);

  //------------------------------apply-----------------------------------
  Future<Either<ApiException, ApplyResponse>> apply(ApplyRequest request);
}
