// features/auth/presentation/cubit/auth_state.dart

part of 'auth_cubit.dart';

class AuthState extends Equatable {
  final BaseState? signInState;
  final BaseState? forgotPasswordState;
  final BaseState? verifyOtpState;
  final BaseState? resetPasswordState;
  final BaseState? applyState;

  const AuthState({
    required this.signInState,
    this.forgotPasswordState,
    this.verifyOtpState,
    this.resetPasswordState,
    this.applyState,
  });

  AuthState copyWith({
    BaseState? signInState,
    BaseState? forgotPasswordState,
    BaseState? verifyOtpState,
    BaseState? resetPasswordState,
    BaseState? applyState,
  }) {
    return AuthState(
      signInState: signInState ?? this.signInState,
      forgotPasswordState: forgotPasswordState ?? this.forgotPasswordState,
      verifyOtpState: verifyOtpState ?? this.verifyOtpState,
      resetPasswordState: resetPasswordState ?? this.resetPasswordState,
      applyState: applyState ?? this.applyState,
    );
  }

  @override
  List<Object?> get props => [
        signInState,
        forgotPasswordState,
        verifyOtpState,
        resetPasswordState,
        applyState,
      ];
}
