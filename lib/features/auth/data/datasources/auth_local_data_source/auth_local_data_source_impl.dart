// features/auth/data/datasource/local_data_source/auth_local_data_source_impl.dart

import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final LocalStorageClient _localStorageClient;

  AuthLocalDataSourceImpl(this._localStorageClient);

  //-----------------------------Token-----------------------------------
  @override
  Future<void> cacheToken(String token) async {
    await _localStorageClient.saveSecuredData('token', token);
  }

  @override
  Future<String?> getToken() async {
    return await _localStorageClient.getSecuredData('token');
  }

  @override
  Future<void> deleteToken() async {
    await _localStorageClient.deleteSecuredData('token');
  }

  @override
  Future<String?> checkSavedToken() async {
    try {
      return await _localStorageClient.getSecuredData('token');
    } catch (e) {
      Log.e('Error checking saved token: $e');
      return null;
    }
  }

  //-----------------------------RememberMe-----------------------------------
  @override
  Future<void> cacheRememberMe(bool rememberMe) async {
    await _localStorageClient.saveData('rememberMe', rememberMe.toString());
  }

  @override
  bool getRememberMe() {
    final value = _localStorageClient.getData('rememberMe');
    return value != null ? value.toLowerCase() == 'true' : false;
  }

  @override
  Future<void> deleteRememberMe() async {
    await _localStorageClient.deleteData('rememberMe');
  }
}
