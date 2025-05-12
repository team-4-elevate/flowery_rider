// features/nav/presentation/cubit/nav_state.dart
import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int tabIndex;

  const NavState({
    required this.tabIndex,
  });

  NavState copyWith({
    int? tabIndex,
  }) {
    return NavState(
      tabIndex: tabIndex ?? this.tabIndex,
    );
  }

  @override
  List<Object?> get props => [
        tabIndex,
      ];
}
