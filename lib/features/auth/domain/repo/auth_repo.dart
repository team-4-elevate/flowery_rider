// features/auth/domain/repo/auth_repo.dart
import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/auth/data/model/login/login_response.dart';
import 'package:flowery_rider/features/auth/data/model/forgetpassword/resetpassword_response.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';

abstract class AuthRepo {
  //-----------------------------signIn-----------------------------------
  Future<Either<Exception, LoginResponse>> signIn(
      String email, String password, bool rememberMe);

  //-----------------------------Check Login Status-----------------------------------
  Future<bool> isUserLoggedIn();

  //-----------------------------Forgot Password-----------------------------------
  Future<Either<Exception, String>> forgotPassword(String email);

  //-----------------------------Verify OTP Code-----------------------------------
  Future<Either<Exception, String>> verifyOtpCode(String email, String code);

  //-----------------------------Reset Password-----------------------------------
  Future<Either<Exception, ResetpasswordResponse>> resetPassword(
      String email, String password);
      
  //-----------------------------Apply as Driver-----------------------------------
  Future<Either<Exception, bool>> apply(ApplyEntity entity);
}
