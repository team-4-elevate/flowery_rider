// features/auth/data/repositories/auth_repo_impl.dart
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:either_dart/either.dart';
import 'package:flowery_rider/core/error_handling/exceptions/api_exception.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/apply/apply_request.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:flowery_rider/generated/locale_keys.g.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);
  @override
  Future<Either<ApiException, LoginResponse>> login(
      LoginRequset loginRequset, bool rememberMe) async {
    try {
      var response = await _authRemoteDataSource.login(loginRequset);

      if (response.token == null) {
        return Left(ApiException(message: LocaleKeys.somethingWentWrong.tr()));
      }
      await _authLocalDataSource.cacheToken(response.token!);
      if (rememberMe) {
        await cacheRememberMe(rememberMe);
      }
      return Right(response);
    } catch (e) {
      return Left(ApiException(message: e.toString()));
    }
  }

  @override
  cacheRememberMe(bool rememberMe) async {
    return await _authLocalDataSource.cacheRememberMe(rememberMe);
  }

  //------------------------------apply-----------------------------------

  @override
  Future<Either<Exception, bool>> apply(ApplyEntity entity) async {
    final licenseExists = await entity.licensePhoto!.exists();
    final idExists = await entity.idPhoto!.exists();
    final request = ApplyRequest.fromEntity(entity);
    final result = await _authRemoteDataSource.apply(request);
    final success = result.right;

    if (entity.licensePhoto == null || entity.idPhoto == null) {
      return Left(Exception('License photo and ID photo are required'));
    }

    if (!licenseExists || !idExists) {
      return Left(
          Exception('Required files do not exist or cannot be accessed'));
    }

    if (result.isLeft) {
      return Left(result.left);
    }

    if (success.token != null && success.driver != null) {
      _authLocalDataSource.cacheToken(success.token!);
    }
    await _authLocalDataSource.saveUserApplyData(entity);

    return Right(success.success);
  }
}
