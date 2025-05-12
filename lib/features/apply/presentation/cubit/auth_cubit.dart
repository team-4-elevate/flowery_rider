import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/apply/domain/repo/auth_repo.dart';
import 'package:flowery_rider/features/auth/presentation/apply/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/usecases/apply_usecase.dart';


@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  final ApplyUseCase? _applyUseCase;

  bool rememberMe = false;
  bool _isFormValid = false;

  AuthCubit( this._authRepo,

      [this._applyUseCase])
      : super(AuthState(
          applyState: BaseInitialState(),
        ));


  void updateFormValidity(bool isValid) {
    _isFormValid = isValid;
  }

  void validateForm(String email, String password) {
    final isValid = email.isNotEmpty &&
        password.isNotEmpty &&
        Validator.emailValidate(email) == null &&
        Validator.passwordValidation(password) == null;

    _isFormValid = isValid;
  }

  bool get isFormValid => _isFormValid;




  // Apply as Driver Methods
  Future<void> apply(ApplyEntity entity) async {
    emit(state.copyWith(applyState: BaseLoadingState()));

    try {

            if (entity.licensePhoto != null && entity.idPhoto != null) {
        try {
          final licenseExists = await entity.licensePhoto!.exists();
          final idExists = await entity.idPhoto!.exists();

          if (!licenseExists || !idExists) {
            emit(state.copyWith(applyState:
              BaseErrorState('Required files could not be accessed. Please try selecting them again.')));
            return;
          }
        } catch (e) {
          debugPrint('DEBUG: Error checking files: $e');
        }
      }

      final result = await _authRepo.apply(entity);

      if (result.isRight) {
        emit(state.copyWith(applyState: BaseSuccessState<bool>(data: result.right)));
      } else {
        emit(state.copyWith(applyState: BaseErrorState(result.left.toString())));
      }
    } catch (e) {
      emit(state.copyWith(applyState: BaseErrorState(e.toString())));
    }
  }

  void resetApplyState() {
    emit(state.copyWith(applyState: BaseInitialState()));
  }
}
