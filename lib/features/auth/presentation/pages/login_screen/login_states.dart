import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';

class LoginStates extends Equatable {
  final BaseState? loginStates;
  final bool? rememberMe;
  const LoginStates(this.loginStates, this.rememberMe);

  LoginStates copyWith({BaseState? loginStates, bool? rememberMe}) {
    return LoginStates(
      loginStates ?? this.loginStates,
      rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [loginStates, rememberMe];
}
