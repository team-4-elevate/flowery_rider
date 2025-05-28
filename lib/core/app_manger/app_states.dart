import 'package:equatable/equatable.dart';

class AppState extends Equatable {
  final bool isLoggedIn;
  final bool hasProfileData;
  final String appLocale; // Default locale
  const AppState({
    this.isLoggedIn = false,
    this.hasProfileData = false,
    this.appLocale = 'en', // Default to English
  });

  factory AppState.initial() => const AppState(hasProfileData: false);

  AppState copyWith(
          {bool? isLoggedIn, bool? hasProfileData, String? appLocale}) =>
      AppState(
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        hasProfileData: hasProfileData ?? this.hasProfileData,
        appLocale: appLocale ?? this.appLocale,
      );

  @override
  List<Object?> get props => [isLoggedIn, hasProfileData, appLocale];
}
