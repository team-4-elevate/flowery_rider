// features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart

import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';

abstract class AuthLocalDataSource {
  //-----------------------------Token-----------------------------------
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> deleteToken();
  Future<String?> checkSavedToken();
  //-----------------------------cacheRememberMe-----------------------------------
  Future<bool> cacheRememberMe(bool rememberMe);
  bool getRememberMe();
  Future<void> deleteRememberMe();

  saveUserApplyData(ApplyEntity entity);
}
