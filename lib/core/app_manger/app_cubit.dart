import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart';
import 'package:flowery_rider/core/app_manger/app_states.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AppCubit extends Cubit<AppState> {
  AppCubit(this._authLocalDataSource, this._localStorageClient)
      : super(const AppState());

  final AuthLocalDataSource _authLocalDataSource;
  final LocalStorageClient _localStorageClient;

  UserDataEntity? _cachedUserProfileData;
  DateTime? _lastProfileFetchTime;

  UserDataEntity? get cachedUserProfileData => _cachedUserProfileData;

  bool hasProfileData() => _cachedUserProfileData != null;

  bool isProfileDataFresh() {
    if (_lastProfileFetchTime == null) return false;
    return DateTime.now().difference(_lastProfileFetchTime!).inMinutes < 30;
  }

  Future<void> getUserLoggedInState() async {
    final hasToken = await _authLocalDataSource.getToken();
    final isLoggedIn = await _authLocalDataSource.getRememberMe() &&
        hasToken != null &&
        hasToken.isNotEmpty;
    emit(state.copyWith(isLoggedIn: isLoggedIn));
  }

  void saveProfileTabData(UserDataEntity profileData) {
    _cachedUserProfileData = profileData;
    _lastProfileFetchTime = DateTime.now();
    emit(state.copyWith(hasProfileData: true));
  }

  Future<String> getAppLocale() async {
    final locale = await _localStorageClient.getData('appLocale') ?? 'en';
    emit(state.copyWith(appLocale: locale));
    return locale;
  }

  void changeAppLocale(String newLocale) async {
    newLocale = state.appLocale == 'en' ? 'ar' : 'en';
    await _localStorageClient.saveData('appLocale', newLocale);

    if (newLocale == state.appLocale) return;
    emit(state.copyWith(appLocale: newLocale));
  }

  void clearProfileData() {
    _cachedUserProfileData = null;
    _lastProfileFetchTime = null;
    emit(state.copyWith(hasProfileData: false));
  }
}
