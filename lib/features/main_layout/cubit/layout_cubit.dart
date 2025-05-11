import 'package:flowery_rider/features/main_layout/cubit/layout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@singleton
class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutState.initial());

  void changeIndex(int index) {
    emit(state.copyWith(bottomNavBarIndex: index));
  }
}