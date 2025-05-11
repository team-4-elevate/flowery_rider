import 'package:flowery_rider/core/app_manger/app_states.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppCubit extends Cubit<AppState> {
  AppCubit(this._authLocalDataSource) : super(const AppState());

  final AuthLocalDataSource _authLocalDataSource;
  // remove this commented code if not used 

  // UserDataEntity? _cachedUserProfileData;
  // DateTime? _lastProfileFetchTime;

  // UserDataEntity? get cachedUserProfileData => _cachedUserProfileData;

  // bool hasProfileData() => _cachedUserProfileData != null;

  // bool isProfileDataFresh() {
  //   if (_lastProfileFetchTime == null) return false;
  //   return DateTime.now().difference(_lastProfileFetchTime!).inMinutes < 30;
  // }



  void getUserLoggedInState() {
    final isLoggedIn = _authLocalDataSource.getRememberMe();
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  // void saveProfileTabData(UserDataEntity profileData) {
  //   _cachedUserProfileData = profileData;
  //   _lastProfileFetchTime = DateTime.now();
  //   emit(state.copyWith(hasProfileData: true));
  // }

  // void clearProfileData() {
  //   _cachedUserProfileData = null;
  //   _lastProfileFetchTime = null;
  //   emit(state.copyWith(hasProfileData: false));
  // }
}
