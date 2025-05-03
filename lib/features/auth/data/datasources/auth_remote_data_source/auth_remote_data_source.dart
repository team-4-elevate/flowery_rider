import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_response/login_response.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponse> login(LoginRequset loginRequset);
}
