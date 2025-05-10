import 'package:equatable/equatable.dart';

class AppStates extends Equatable {
  final int bottomNavBarIndex;
  final bool isLoggedIn;
  final bool haseProfileData;
  const AppStates({
    required this.bottomNavBarIndex,
    this.isLoggedIn = false,
    this.haseProfileData = false,
  });

  factory AppStates.initial() => const AppStates(
      bottomNavBarIndex: 0, isLoggedIn: false, haseProfileData: false);

  AppStates copyWith(
          {int? bottomNavBarIndex, bool? isLoggedIn, bool? haseProfileData}) =>
      AppStates(
          bottomNavBarIndex: bottomNavBarIndex ?? this.bottomNavBarIndex,
          isLoggedIn: isLoggedIn ?? this.isLoggedIn,
          haseProfileData: haseProfileData ?? this.haseProfileData);

  @override
  List<Object?> get props => [bottomNavBarIndex, isLoggedIn, haseProfileData];
}
