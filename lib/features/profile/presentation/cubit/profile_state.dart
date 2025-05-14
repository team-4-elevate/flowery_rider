import 'package:equatable/equatable.dart';
import 'package:flowery_rider/core/base/base_state.dart';

class ProfileState extends Equatable {
  final BaseState ? getUserDataState;
  final BaseState ? updateUserDataState;
  final BaseState ? updateCarInfoState;
  const ProfileState({
    this.getUserDataState,
    this.updateUserDataState,
    this.updateCarInfoState,
  });

ProfileState copyWith({
    BaseState? getUserDataState,
    BaseState? updateUserDataState,
    BaseState? updateCarInfoState,
  }) {
    return ProfileState(
      getUserDataState: getUserDataState ?? this.getUserDataState,
      updateUserDataState: updateUserDataState ?? this.updateUserDataState,
      updateCarInfoState: updateCarInfoState ?? this.updateCarInfoState,
    );
  }

  @override
  List<Object?> get props => [
        getUserDataState,
        updateUserDataState,
        updateCarInfoState
  ];
}
