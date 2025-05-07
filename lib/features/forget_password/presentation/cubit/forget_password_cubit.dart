import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/forget_password/domain/usecases/reset_password_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/forget_password_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import 'forget_psasword_state.dart';

@injectable
class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final ResendOtpUseCase _resendOtpUseCase;
  final ForgetPasswordUseCase _forgetPasswordUseCase;
  final VerifyOtpUseCase _verifyResetCodeUseCase;
  final ResetPasswordUseCase _resetPasswordUseCase;

  ForgetPasswordCubit(this._forgetPasswordUseCase, this._resendOtpUseCase,
      this._resetPasswordUseCase, this._verifyResetCodeUseCase)
      : super(ForgetPasswordState());

  Future<void> forgetPassword(String email) async {
    emit(state.copyWith(
        forgetPasswordState: BaseLoadingState(), userEmail: email));
    try {
      await _forgetPasswordUseCase(email);
      emit(state.copyWith(forgetPasswordState: BaseSuccessState()));
    } catch (e) {
      emit(state.copyWith(forgetPasswordState: BaseErrorState(e.toString())));
    }
  }

  Future<void> verifyResetCode(String resetCode) async {
    emit(state.copyWith(verifyResetCodeState: BaseLoadingState()));

    try {
      await _verifyResetCodeUseCase(resetCode);
      emit(state.copyWith(verifyResetCodeState: BaseSuccessState()));
    } catch (e) {
      emit(state.copyWith(verifyResetCodeState: BaseErrorState(e.toString())));
    }
  }

  Future<void> resendOtp() async {
    emit(state.copyWith(resendOtpState: BaseLoadingState()));
    try {
      await _resendOtpUseCase(state.userEmail!);
      emit(state.copyWith(resendOtpState: BaseSuccessState()));
    } catch (e) {
      emit(state.copyWith(resendOtpState: BaseErrorState(e.toString())));
    }
  }

  Future<void> resetPassword(
      {required String email, required String newPassword}) async {
    try {
      emit(state.copyWith(resetPasswordState: BaseLoadingState()));
      await _resetPasswordUseCase(email: email, newPassword: newPassword);
      emit(state.copyWith(resetPasswordState: BaseSuccessState()));
    } catch (e) {
      emit(state.copyWith(resetPasswordState: BaseErrorState(e.toString())));
    }
  }
}
