import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/domain/usecases/cache_remember_me_usecase.dart';
import 'package:flowery_rider/features/auth/domain/usecases/login_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(
    this._loginUseCase,
    this._cacheRememberMeUsecase,
  ) : super(LoginStates(BaseInitialState()));

  final LoginUseCase _loginUseCase;
  final CacheRememberMeUsecase _cacheRememberMeUsecase;
  // final AuthLocalDataSource _authLocalDataSource;

  void doLogin(String email, String password) async {
    emit(state.copyWith(loginStates: BaseLoadingState()));
    var response = await _loginUseCase.call(
      LoginRequset(email: email, password: password),
      state.rememberMe,
    );

    response.fold(
      (error) {
        emit(state.copyWith(loginStates: BaseErrorState(error.message)));
      },
      (loginResponse) async {
        // await _handleTokenCaching(loginResponse.token);
        emit(state.copyWith(loginStates: BaseSuccessState()));
      },
    );
  }

  Future<void> changeRememberMe(bool value) async {
    emit(state.copyWith(rememberMe: value));
    await _cacheRememberMeUsecase.call(value);
  }
}
