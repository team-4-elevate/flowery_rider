import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final bool isLoggedIn;
  // final bool hasProfileData;
  const AppState({
    this.isLoggedIn = false,
    // this.hasProfileData = false,
  });

  factory AppState.initial() => const AppState(
        // hasProfileData: false
      );

  AppState copyWith({
    bool? isLoggedIn,
    // bool ? hasProfileData
  }) =>
      AppState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        // hasProfileData: hasProfileData ?? this.hasProfileData
      );

  @override
  List<Object?> get props => [
        isLoggedIn,
        // hasProfileData
      ];
}
