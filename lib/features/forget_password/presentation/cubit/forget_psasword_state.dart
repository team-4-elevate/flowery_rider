import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';

class ForgetPasswordState extends Equatable {
  final BaseState? forgetPasswordState;
  final BaseState? verifyResetCodeState;
  final BaseState? resetPasswordState;
  final BaseState? resendOtpState;
  final String? userEmail;

  const ForgetPasswordState({
    this.forgetPasswordState,
    this.verifyResetCodeState,
    this.resetPasswordState,
    this.resendOtpState,
    this.userEmail,
  });

  ForgetPasswordState copyWith({
    BaseState? forgetPasswordState,
    BaseState? verifyResetCodeState,
    BaseState? resetPasswordState,
    BaseState? resendOtpState,
    String? userEmail,
  }) {
    return ForgetPasswordState(
        forgetPasswordState: forgetPasswordState ?? this.forgetPasswordState,
        resetPasswordState: resetPasswordState ?? this.resetPasswordState,
        resendOtpState: resendOtpState ?? this.resendOtpState,
        userEmail: userEmail ?? this.userEmail,
        verifyResetCodeState:
            verifyResetCodeState ?? this.verifyResetCodeState);
  }

  @override
  List<Object?> get props => [
        forgetPasswordState,
        verifyResetCodeState,
        resetPasswordState,
        resendOtpState,
        userEmail
      ];
}
