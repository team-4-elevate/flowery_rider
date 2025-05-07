import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart';
import 'package:injectable/injectable.dart';
import 'forget_password_local_sd_i.dart';

@Injectable(as: ForgetPasswordLocalDsI)
class ForgetPasswordLocalDsImpl implements ForgetPasswordLocalDsI {
  final LocalStorageClient _localStorageClient;
  ForgetPasswordLocalDsImpl(this._localStorageClient);
  @override
  Future<void> saveResetPasswordToken(String token) async {
    await _localStorageClient.saveSecuredData('token', token);
  }
}
