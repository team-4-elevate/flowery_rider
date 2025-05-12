// features/auth/presentation/apply/cubit/auth_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';
import 'package:flowery_rider/features/apply/domain/entities/apply_entity.dart';
import 'package:flowery_rider/features/auth/domain/repositories/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
part 'auth_state.dart';

@injectable
class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(AuthState(applyState: BaseInitialState()));

//------------------------------------------- apply ---------------------------
  Future<void> apply(Map<String, dynamic> formData) async {
    emit(state.copyWith(applyState: BaseLoadingState()));
    try {
      final entity = ApplyEntity.fromFormData(
        firstName: formData['firstName'] as String,
        lastName: formData['lastName'] as String,
        email: formData['email'] as String,
        phone: formData['phone'] as String,
        countryCode: formData['countryCode'] as String,
        gender: formData['gender'] as String,
        vehicleType: formData['vehicleType'] as String,
        vehicleNumber: formData['vehicleNumber'] as String,
        idNumber: formData['idNumber'] as String,
        password: formData['password'] as String,
        licensePhoto: formData['licensePhoto'],
        idPhoto: formData['idPhoto'],
      );

      final result = await _authRepo.apply(entity);
      if (result.isRight) {
        emit(state.copyWith(
            applyState: BaseSuccessState<bool>(data: result.right)));
      } else {
        emit(
            state.copyWith(applyState: BaseErrorState(result.left.toString())));
      }
    } catch (e) {
      debugPrint('Apply error: $e');
      emit(state.copyWith(applyState: BaseErrorState(e.toString())));
    }
  }

  void resetApplyState() {
    emit(state.copyWith(applyState: BaseInitialState()));
  }
  //----------------------------------------------------------------
}
