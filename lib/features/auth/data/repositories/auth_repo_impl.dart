import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;

  AuthRepoImpl(this._authRemoteDataSource);
  @override
  Future<Either<ApiException, LoginResponse>> login(
      LoginRequset loginRequset, bool rememberMe) async {
    try {
      var reponse = await _authRemoteDataSource.login(loginRequset);
      return Right(reponse);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }
}
