import 'package:equatable/equatable.dart';
import 'package:flowery_rider/features/profile/domain/entities/user_data_enitiy.dart';
import 'package:flowery_rider/features/profile/presentation/cubit/result.dart';

class ProfileState extends Equatable {
  final Result<UserDataEntity> userData;
  final Result<UserDataEntity> updateUserData;
  final Result<void> updateCarInfo;
  final Result<void> changePassword;
  final Result<void> logout;

    const ProfileState({
    this.userData = const Result<UserDataEntity>.initial(),
    this.updateUserData = const Result<UserDataEntity>.initial(),
    this.updateCarInfo = const Result<void>.initial(),
    this.changePassword = const Result<void>.initial(),
    this.logout = const Result<void>.initial(),
  });

  ProfileState copyWith({
    Result<UserDataEntity>? userData,
    Result<UserDataEntity>? updateUserData,
    Result<void>? updateCarInfo,
    Result<void>? changePassword,
    Result<void>? logout,
  }) {
    return ProfileState(
      userData: userData ?? this.userData,
      updateUserData: updateUserData ?? this.updateUserData,
      updateCarInfo: updateCarInfo ?? this.updateCarInfo,
      changePassword: changePassword ?? this.changePassword,
      logout: logout ?? this.logout,
    );
  }

  @override
  List<Object?> get props => [
        userData,
        updateUserData,
        updateCarInfo,
        changePassword,
        logout,
      ];
}
