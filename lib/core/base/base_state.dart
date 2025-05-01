sealed class BaseState {}

class BaseInitialState extends BaseState {}

class BaseSuccessState<T> extends BaseState {
  T? data;
  BaseSuccessState({this.data});
}

class BaseLoadingState extends BaseState {}

class BaseErrorState extends BaseState {
  String errorMessage;
  BaseErrorState(this.errorMessage);
}
