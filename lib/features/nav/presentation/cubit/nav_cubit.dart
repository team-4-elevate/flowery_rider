// features/nav/presentation/cubit/nav_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'nav_state.dart';

@lazySingleton
class NavCubit extends Cubit<NavState> {
  NavCubit() : super(const NavState(tabIndex: 0));

  void changeTab(int index, {int? selectedCategoryIndex}) {
    emit(state.copyWith(
      tabIndex: index,
    ));
  }
}
