// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flowery_rider/core/app_data/api/api_client.dart' as _i452;
import 'package:flowery_rider/core/app_data/api/dio_client.dart' as _i862;
import 'package:flowery_rider/core/app_data/local_storage/local_storage_client.dart'
    as _i983;
import 'package:flowery_rider/core/di/modules.dart' as _i851;
import 'package:flowery_rider/core/error_handling/dio_error_handler.dart'
    as _i388;
import 'package:flowery_rider/core/routes/navigator_observer.dart' as _i944;
import 'package:flowery_rider/core/widget/dialog_utils.dart' as _i318;
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart'
    as _i902;
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source_impl.dart'
    as _i348;
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source.dart'
    as _i614;
import 'package:flowery_rider/features/auth/data/datasources/auth_remote_data_source/auth_remote_data_source_impl.dart'
    as _i363;
import 'package:flowery_rider/features/auth/data/repositories/auth_repo_impl.dart'
    as _i683;
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart'
    as _i351;
import 'package:flowery_rider/features/auth/domain/usecases/apply_usecase.dart'
    as _i929;
import 'package:flowery_rider/features/auth/domain/usecases/cache_remember_me_usecase.dart'
    as _i597;
import 'package:flowery_rider/features/auth/domain/usecases/login_use_case.dart'
    as _i968;
import 'package:flowery_rider/features/auth/presentation/apply/cubit/auth_cubit.dart'
    as _i394;
import 'package:flowery_rider/features/auth/presentation/login_screen/login_cubit.dart'
    as _i364;
import 'package:flowery_rider/features/forget_password/data/data_sources/local_data_source/forget_password_local_ds_impl.dart'
    as _i316;
import 'package:flowery_rider/features/forget_password/data/data_sources/local_data_source/forget_password_local_sd_i.dart'
    as _i650;
import 'package:flowery_rider/features/forget_password/data/data_sources/remote_data_source/forget_password_remote_ds_i.dart'
    as _i1016;
import 'package:flowery_rider/features/forget_password/data/data_sources/remote_data_source/forget_password_remote_ds_impl.dart'
    as _i785;
import 'package:flowery_rider/features/forget_password/data/repo_impl/forget_password_repo_impl.dart'
    as _i259;
import 'package:flowery_rider/features/forget_password/domain/repo_interface/forget_password_repo_interface.dart'
    as _i78;
import 'package:flowery_rider/features/forget_password/domain/usecases/forget_password_usecase.dart'
    as _i442;
import 'package:flowery_rider/features/forget_password/domain/usecases/resend_otp_usecase.dart'
    as _i542;
import 'package:flowery_rider/features/forget_password/domain/usecases/reset_password_use_case.dart'
    as _i592;
import 'package:flowery_rider/features/forget_password/domain/usecases/verify_otp_usecase.dart'
    as _i1007;
import 'package:flowery_rider/features/forget_password/presentation/cubit/forget_password_cubit.dart'
    as _i107;
import 'package:flutter/cupertino.dart' as _i719;
import 'package:flutter/material.dart' as _i409;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final getItRegisterModule = _$GetItRegisterModule();
    gh.singleton<_i409.GlobalKey<_i409.NavigatorState>>(
        () => getItRegisterModule.navigatorKey);
    gh.singleton<_i973.InternetConnectionChecker>(
        () => getItRegisterModule.checker);
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => getItRegisterModule.sharedPreferences,
      preResolve: true,
    );
    gh.singleton<_i558.FlutterSecureStorage>(
        () => getItRegisterModule.secureStorage);
    gh.singleton<_i944.AppNavigatorObserver>(
        () => _i944.AppNavigatorObserver());
    gh.singleton<_i318.DialogUtils>(() => _i318.DialogUtils());
    gh.singleton<_i983.LocalStorageClient>(() => _i983.LocalStorageClient(
          gh<_i460.SharedPreferences>(),
          gh<_i558.FlutterSecureStorage>(),
        ));
    gh.singleton<_i388.DioErrorHandler>(() => _i388.DioErrorHandler(
          gh<_i983.LocalStorageClient>(),
          gh<_i719.GlobalKey<_i719.NavigatorState>>(),
        ));
    gh.factory<_i902.AuthLocalDataSource>(
        () => _i348.AuthLocalDataSourceImpl(gh<_i983.LocalStorageClient>()));
    gh.factory<_i650.ForgetPasswordLocalDsI>(
        () => _i316.ForgetPasswordLocalDsImpl(gh<_i983.LocalStorageClient>()));
    gh.singleton<_i452.ApiClient>(() => _i862.DioApiClient(
          gh<_i983.LocalStorageClient>(),
          gh<_i388.DioErrorHandler>(),
          gh<_i719.GlobalKey<_i719.NavigatorState>>(),
        ));
    gh.factory<_i1016.ForgetPasswordRemoteDsI>(
        () => _i785.ForgetPasswordRemoteDsImpl(gh<_i452.ApiClient>()));
    gh.factory<_i614.AuthRemoteDataSource>(
        () => _i363.AuthRemoteDataSourceImpl(gh<_i452.ApiClient>()));
    gh.factory<_i78.ForgetPasswordRepoI>(() => _i259.ForgetPasswordRepoImpl(
          gh<_i1016.ForgetPasswordRemoteDsI>(),
          gh<_i650.ForgetPasswordLocalDsI>(),
        ));
    gh.factory<_i351.AuthRepo>(() => _i683.AuthRepoImpl(
          gh<_i614.AuthRemoteDataSource>(),
          gh<_i902.AuthLocalDataSource>(),
        ));
    gh.factory<_i442.ForgetPasswordUseCase>(
        () => _i442.ForgetPasswordUseCase(gh<_i78.ForgetPasswordRepoI>()));
    gh.factory<_i542.ResendOtpUseCase>(
        () => _i542.ResendOtpUseCase(gh<_i78.ForgetPasswordRepoI>()));
    gh.factory<_i1007.VerifyOtpUseCase>(
        () => _i1007.VerifyOtpUseCase(gh<_i78.ForgetPasswordRepoI>()));
    gh.factory<_i394.AuthCubit>(() => _i394.AuthCubit(
          gh<_i351.AuthRepo>(),
          gh<_i929.ApplyUseCase>(),
        ));
    gh.factory<_i929.ApplyUseCase>(
        () => _i929.ApplyUseCase(gh<_i351.AuthRepo>()));
    gh.factory<_i597.CacheRememberMeUsecase>(
        () => _i597.CacheRememberMeUsecase(gh<_i351.AuthRepo>()));
    gh.factory<_i968.LoginUseCase>(
        () => _i968.LoginUseCase(gh<_i351.AuthRepo>()));
    gh.factory<_i592.ResetPasswordUseCase>(
        () => _i592.ResetPasswordUseCase(gh<_i78.ForgetPasswordRepoI>()));
    gh.factory<_i107.ForgetPasswordCubit>(() => _i107.ForgetPasswordCubit(
          gh<_i442.ForgetPasswordUseCase>(),
          gh<_i542.ResendOtpUseCase>(),
          gh<_i592.ResetPasswordUseCase>(),
          gh<_i1007.VerifyOtpUseCase>(),
        ));
    gh.factory<_i364.LoginCubit>(() => _i364.LoginCubit(
          gh<_i968.LoginUseCase>(),
          gh<_i597.CacheRememberMeUsecase>(),
        ));
    return this;
  }
}

class _$GetItRegisterModule extends _i851.GetItRegisterModule {}
