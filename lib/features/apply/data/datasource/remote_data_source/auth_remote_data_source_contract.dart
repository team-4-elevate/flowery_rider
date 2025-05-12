// features/apply/data/datasource/remote_data_source/auth_remote_data_source_contract.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/apply/data/model/apply/apply_request.dart';
import 'package:flowery_rider/features/apply/data/model/apply/apply_response.dart';

abstract class AuthRemoteDataSourceContract {
  //------------------------------apply-----------------------------------
  Future<Either<ApiException, ApplyResponse>> apply(ApplyRequest request);
}
