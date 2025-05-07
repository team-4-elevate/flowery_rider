// features/auth/data/datasource/local_data_source/auth_loca_data_source_impl.dart

import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart';
import 'package:flowery_rider/core/logger/app_logger.dart';
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AuthLocalDataSourceContract)
class AuthLocalDataSourceImpl implements AuthLocalDataSourceContract {
  final LocalStorageClient _localStorageClient;

  AuthLocalDataSourceImpl(this._localStorageClient);

  //-----------------------------Token-----------------------------------
  @override
  Future<void> cacheToken(String token) async {
    try {
      await _localStorageClient.saveSecuredData('token', token);
    } catch (e) {
      Log.e('Error saving token: $e');
    }
  }

  @override
  Future<String?> getToken() async {
    try {
      return await _localStorageClient.getSecuredData('token');
    } catch (e) {
      Log.e('Error getting token: $e');
      return null;
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await _localStorageClient.deleteSecuredData('token');
    } catch (e) {
      Log.e('Error deleting token: $e');
    }
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
    try {
      await _localStorageClient.saveData('rememberMe', rememberMe.toString());
    } catch (e) {
      Log.e('Error saving remember me: $e');
    }
  }

  @override
  bool getRememberMe() {
    try {
      Log.d('getting rememberMe');
      final value = _localStorageClient.getData('rememberMe');
      return value != null ? value.toLowerCase() == 'true' : false;
    } catch (e) {
      Log.e('Error getting remember me: $e');
      return false;
    }
  }

  @override
  Future<void> deleteRememberMe() async {
    try {
      await _localStorageClient.deleteData('rememberMe');
    } catch (e) {
      Log.e('Error deleting remember me: $e');
    }
  }
}
