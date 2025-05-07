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
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_loca_data_source_impl.dart'
    as _i688;
import 'package:flowery_rider/features/auth/data/datasource/local_data_source/auth_local_data_source_contract.dart'
    as _i816;
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_contract.dart'
    as _i692;
import 'package:flowery_rider/features/auth/data/datasource/remote_data_source/auth_remote_data_source_impl.dart'
    as _i318;
import 'package:flowery_rider/features/auth/data/repo/auth_repo.dart' as _i875;
import 'package:flowery_rider/features/auth/domain/repo/auth_repo.dart'
    as _i1032;
import 'package:flowery_rider/features/auth/domain/use_case/apply_usecase.dart'
    as _i149;
import 'package:flowery_rider/features/auth/domain/use_case/forgetpassword_usecase.dart'
    as _i117;
import 'package:flowery_rider/features/auth/domain/use_case/login_usecase.dart'
    as _i245;
import 'package:flowery_rider/features/auth/presentation/cubit/auth_cubit.dart'
    as _i908;
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
    gh.factory<_i816.AuthLocalDataSourceContract>(
        () => _i688.AuthLocalDataSourceImpl(gh<_i983.LocalStorageClient>()));
    gh.singleton<_i452.ApiClient>(() => _i862.DioApiClient(
          gh<_i983.LocalStorageClient>(),
          gh<_i388.DioErrorHandler>(),
          gh<_i719.GlobalKey<_i719.NavigatorState>>(),
        ));
    gh.factory<_i692.AuthRemoteDataSourceContract>(
        () => _i318.AuthRemoteDataSourceImpl(gh<_i452.ApiClient>()));
    gh.factory<_i1032.AuthRepo>(() => _i875.AuthRepositoryImpl(
          gh<_i692.AuthRemoteDataSourceContract>(),
          gh<_i816.AuthLocalDataSourceContract>(),
        ));
    gh.factory<_i149.ApplyUseCase>(
        () => _i149.ApplyUseCase(gh<_i1032.AuthRepo>()));
    gh.factory<_i117.ForgotPasswordUseCase>(
        () => _i117.ForgotPasswordUseCase(gh<_i1032.AuthRepo>()));
    gh.factory<_i117.VerifyOtpCodeUseCase>(
        () => _i117.VerifyOtpCodeUseCase(gh<_i1032.AuthRepo>()));
    gh.factory<_i117.ResetPasswordUseCase>(
        () => _i117.ResetPasswordUseCase(gh<_i1032.AuthRepo>()));
    gh.factory<_i245.LoginUseCase>(
        () => _i245.LoginUseCase(gh<_i1032.AuthRepo>()));
    gh.factory<_i908.AuthCubit>(() => _i908.AuthCubit(
          gh<_i245.LoginUseCase>(),
          gh<_i1032.AuthRepo>(),
          gh<_i117.ForgotPasswordUseCase>(),
          gh<_i117.VerifyOtpCodeUseCase>(),
          gh<_i117.ResetPasswordUseCase>(),
          gh<_i149.ApplyUseCase>(),
        ));
    return this;
  }
}

class _$GetItRegisterModule extends _i851.GetItRegisterModule {}
