import 'package:equatable/equatable.dart';

class LayoutState extends Equatable {
  final int bottomNavBarIndex;
  const LayoutState(
    this.bottomNavBarIndex,
  );

  factory LayoutState.initial() => const LayoutState(0);

  LayoutState copyWith({
    int? bottomNavBarIndex,
  }) {
    return LayoutState(
      bottomNavBarIndex ?? this.bottomNavBarIndex,
    );
  }

  @override
  List<Object> get props => [
        bottomNavBarIndex,
      ];
}
