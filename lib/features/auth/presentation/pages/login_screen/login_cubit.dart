import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/auth/data/datasources/auth_local_data_source/auth_local_data_source.dart';
import 'package:flowery_rider/features/auth/data/models/login_model/login_requset/login_requset.dart';
import 'package:flowery_rider/features/auth/domain/usecases/login_use_case.dart';
import 'package:flowery_rider/features/auth/presentation/pages/login_screen/login_states.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoginCubit extends Cubit<LoginStates> {
  LoginCubit(this._loginUseCase, this._authLocalDataSource)
      : super(LoginStates(
        BaseInitialState(),
       false
      ));
  
  final LoginUseCase _loginUseCase;
  final AuthLocalDataSource _authLocalDataSource;

  ValueNotifier<bool> rememberMe = ValueNotifier(false);
void doLogin(String email, String password) async {
  emit(state.copyWith(loginStates: BaseLoadingState()));
  var response = await _loginUseCase.call(
    LoginRequset(email: email, password: password),
    rememberMe.value,
  );

  response.fold(
    (error) {
      emit(state.copyWith(loginStates: BaseErrorState(error.message)));
    },
    (loginResponse) async {
      await _handleTokenCaching(loginResponse.token);
      emit(state.copyWith(loginStates: BaseSuccessState()));
    },
  );
}

  Future<void> _handleTokenCaching(String? token) async {
    if (rememberMe.value && token != null) {
      await _authLocalDataSource.cacheToken(token);
    }
  }

  void changeRememberMe(bool value) {
    rememberMe.value = value;
     _authLocalDataSource.cacheRememberMe(value); 
    emit(state.copyWith(rememberMe: rememberMe.value));
  }
}