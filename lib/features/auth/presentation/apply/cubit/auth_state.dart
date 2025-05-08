// features/apply/presentation/cubit/auth_state.dart

part of 'auth_cubit.dart';

class AuthState extends Equatable {

  final BaseState? applyState;

  const AuthState({
    this.applyState,
  });

  AuthState copyWith({
    BaseState? applyState,
  }) {
    return AuthState(

      applyState: applyState ?? this.applyState,
    );
  }

  @override
  List<Object?> get props => [
        applyState,
      ];
}
