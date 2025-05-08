// features/auth/presentation/apply/cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/core/utils/validator.dart';
import 'package:flowery_rider/features/auth/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:flowery_rider/features/auth/domain/usecases/apply_usecase.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final ApplyUseCase? _applyUseCase;
  bool _isFormValid = false;

  AuthCubit(this._authRepo, [this._applyUseCase])
      : super(AuthState(applyState: BaseInitialState()));


//------------------------------------------- apply ---------------------------
  Future<void> apply(ApplyEntity entity) async {
    emit(state.copyWith(applyState: BaseLoadingState()));

    try {
      if (!await _areFilesValid(entity)) return;
      final result = await _authRepo.apply(entity);

      if (result.isRight) {
        emit(state.copyWith(
            applyState: BaseSuccessState<bool>(data: result.right)));
      } else {
        emit(
            state.copyWith(applyState: BaseErrorState(result.left.toString())));
      }
    } catch (e) {
      emit(state.copyWith(applyState: BaseErrorState(e.toString())));
    }
  }

  void resetApplyState() {
    emit(state.copyWith(applyState: BaseInitialState()));
  }

  Future<bool> _areFilesValid(ApplyEntity entity) async {
    if (entity.licensePhoto == null || entity.idPhoto == null) {
      emit(state.copyWith(
          applyState:
              BaseErrorState('License photo and ID photo are required')));
      return false;
    }

    try {
      final licenseExists = await entity.licensePhoto!.exists();
      final idExists = await entity.idPhoto!.exists();

      if (!licenseExists || !idExists) {
        emit(state.copyWith(
            applyState: BaseErrorState(
                'Required files could not be accessed. Please try selecting them again.')));
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('File validation error: $e');
      return false;
    }
  }
  //----------------------------------------------------------------
}
