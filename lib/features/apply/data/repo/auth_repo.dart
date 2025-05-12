import 'package:either_dart/either.dart';
import 'package:flowery_rider/features/apply/data/datasource/remote_data_source/auth_remote_data_source_contract.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/apply/domain/repo/auth_repo.dart';
import 'package:flowery_rider/features/auth/data/models/apply/apply_request.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';

@Injectable(as: AuthRepo)
class AuthRepositoryImpl implements AuthRepo {
  final AuthRemoteDataSourceContract _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  //------------------------------apply-----------------------------------

  @override
  Future<Either<Exception, bool>> apply(ApplyEntity entity) async {
    if (entity.licensePhoto == null || entity.idPhoto == null) {
      return Left(Exception('License photo and ID photo are required'));
    }

    final licenseExists = await entity.licensePhoto!.exists();
    final idExists = await entity.idPhoto!.exists();

    if (!licenseExists || !idExists) {
      return Left(
          Exception('Required files do not exist or cannot be accessed'));
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
