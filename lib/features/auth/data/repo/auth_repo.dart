// features/auth/data/repo/auth_repo.dart

import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/auth/data/model/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';
import 'package:flowery_rider/features/auth/data/model/forgetpassword/resetpassword_response.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSourceContract _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);



//-----------------------------signIn-----------------------------------
  @override
  Future<Either<Exception, LoginResponse>> signIn(
      String email, String password, bool rememberMe) async {
    try {
      final result = await _remoteDataSource.signIn(email, password);

      if (result.isLeft) {
        return Left(result.left);
      }
      
      final loginResponse = result.right;
      if (loginResponse.token != null) {
        // Always cache the token regardless of rememberMe to enable current session
        _localDataSource.cacheToken(loginResponse.token!);
        
        // The rememberMe flag only affects persistence settings
        _localDataSource.cacheRememberMe(rememberMe);

        return Right(loginResponse);
      } else {
        return Left(Exception('Authentication failed: Token is null'));
      }
    } catch (e) {
      return Left(Exception('Authentication failed: ${e.toString()}'));
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await _localDataSource.checkSavedToken();
      final rememberMe = _localDataSource.getRememberMe();
      return token != null && rememberMe;
    } catch (e) {
      return false;
    }
  }


  //------------------------------forgotPassword-----------------------------------

  @override
  Future<Either<Exception, String>> forgotPassword(String email) async {
    try {
      final result = await _remoteDataSource.forgotPassword(email);

      if (result.isLeft) {
        return Left(Exception(result.left.message));
      }
      
      return Right(result.right);
    } catch (e) {
      return Left(Exception('Forgot password request failed: ${e.toString()}'));
    }
  }


  //------------------------------verifyOtpCode-----------------------------------

  @override
  Future<Either<Exception, String>> verifyOtpCode(
      String email, String code) async {
    try {
      final result = await _remoteDataSource.verifyOtpCode(email, code);

      if (result.isLeft) {
        return Left(Exception(result.left.message));
      }
      
      return Right(result.right);
    } catch (e) {
      return Left(Exception('OTP verification failed: ${e.toString()}'));
    }
  }


  //------------------------------resetPassword-----------------------------------

  @override
  Future<Either<Exception, ResetpasswordResponse>> resetPassword(
      String email, String password) async {
    try {
      final result = await _remoteDataSource.resetPassword(email, password);

      if (result.isLeft) {
        return Left(Exception(result.left.message));
      }
      
      final loginResponse = result.right;
      if (loginResponse.token != null) {
        _localDataSource.cacheToken(loginResponse.token!);
        _localDataSource.cacheRememberMe(true);

        final resetpasswordResponse = ResetpasswordResponse(
          message: loginResponse.message,
          token: loginResponse.token
        );

        return Right(resetpasswordResponse);
      } else {
        return Left(Exception('Password reset failed: Token is null'));
      }
    } catch (e) {
      return Left(Exception('Password reset failed: ${e.toString()}'));
    }
  }


  //------------------------------apply-----------------------------------

  @override
  Future<Either<Exception, bool>> apply(ApplyEntity entity) async {
    if (entity.licensePhoto == null || entity.idPhoto == null) {
      return Left(Exception('License photo and ID photo are required'));
    }

    final licenseExists = await entity.licensePhoto!.exists();
    final idExists = await entity.idPhoto!.exists();
    
    if (!licenseExists || !idExists) {
      return Left(Exception('Required files do not exist or cannot be accessed'));
    }
    
    final request = ApplyRequest.fromEntity(entity);
    final result = await _remoteDataSource.apply(request);
    
    if (result.isLeft) {
      return Left(result.left);
    }
    
    final success = result.right;
    if (success.token != null && success.driver != null) {
      _localDataSource.cacheToken(success.token!);
    }
    
    return Right(success.success);
  }
}
