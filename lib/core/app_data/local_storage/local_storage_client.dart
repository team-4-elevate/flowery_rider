import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../error_handling/exceptions/local_storage_exception.dart';
import '../../logger/app_logger.dart';

@singleton
class LocalStorageClient {
  SharedPreferences sharedPreferences;
  FlutterSecureStorage secureStorage;

  LocalStorageClient(
    this.sharedPreferences,
    this.secureStorage,
  );

  Future<bool>? saveData(String key, String value) async {
    try {
      return await sharedPreferences.setString(key, value);
    } catch (e) {
      throw LocalStorageException('Failed to save data: ${e.toString()}');
    }
  }

  String? getData(String key) {
    try {
      Log.d('getting $key');
      return sharedPreferences.getString(
        key,
      );
    } catch (e) {
      throw LocalStorageException('Failed to get data: ${e.toString()}');
    }
  }

  Future<void> saveSecuredData(String key, String value) async {
    try {
      Log.d('saving $key');
      return await secureStorage.write(key: key, value: value);
    } catch (e) {
      throw LocalStorageException('Failed to save data: ${e.toString()}');
    }
  }

  Future<String?> getSecuredData(String key) async {
    try {
      Log.d('getting $key');
      return await secureStorage.read(key: key);
    } catch (e) {
      throw LocalStorageException('Failed to get data: ${e.toString()}');
    }
  }

  Future<void>? deleteData(String key) async {
    try {
      await sharedPreferences.remove(key);
    } catch (e) {
      throw LocalStorageException('Failed to delete data: ${e.toString()}');
    }
  }

  Future<void>? deleteSecuredData(String key) async {
    try {
      Log.d('deleting $key');
      await secureStorage.delete(key: key);
    } catch (e) {
      throw LocalStorageException('Failed to delete data: ${e.toString()}');
    }
  }

  bool? getRememberMe() {
    try {
      bool? rememberMe = sharedPreferences.getBool('rememberUser');
      Log.i('got rememberMe with $rememberMe');
      return rememberMe;
    } catch (e) {
      Log.e(e.toString());
      throw LocalStorageException('Failed to get data: ${e.toString()}');
    }
  }

  Future<void> saveRememberMe(bool rememberMe) async {
    try {
      Log.d('saving rememberMe with $rememberMe');
      await sharedPreferences.setBool('rememberUser', rememberMe);
    } catch (e) {
      throw LocalStorageException('Failed to save data: ${e.toString()}');
    }
  }
}
