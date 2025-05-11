import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final int bottomNavBarIndex;
  final bool isLoggedIn;
  final bool hasProfileData;
  const AppState({
    required this.bottomNavBarIndex,
    this.isLoggedIn = false,
    this.hasProfileData = false,
  });

  factory AppState.initial() =>
      const AppState(bottomNavBarIndex: 0, isLoggedIn: false, 
      hasProfileData: false
      );

  AppState copyWith({
    int? bottomNavBarIndex,
    bool? isLoggedIn,
    bool ? hasProfileData
  }) =>
      AppState(
        bottomNavBarIndex: bottomNavBarIndex ?? this.bottomNavBarIndex,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        hasProfileData: hasProfileData ?? this.hasProfileData
      );

  @override
  List<Object?> get props => [
        bottomNavBarIndex,
        isLoggedIn,
        hasProfileData
      ];
}
