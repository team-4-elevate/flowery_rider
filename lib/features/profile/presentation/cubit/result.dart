/// Represents the result of an operation that can be in different states:
/// initial, loading, success with data, or error.
class Result<T> {
  final T? data;
  final String? error;
  final bool isLoading;

  const Result._({
    this.data,
    this.error,
    this.isLoading = false,
  });

 const Result.initial() : data = null, error = null, isLoading = false;
  
  factory Result.loading() => const Result._(isLoading: true);
  
  factory Result.success(T data) => Result._(data: data);
  
  factory Result.error(String message) => Result._(error: message);

  bool get isInitial => !isLoading && data == null && error == null;
  bool get isSuccess => data != null;
  bool get isError => error != null;

  /// Safely get data or return null
  T? getOrNull() => data;
  
  /// Safely get data or return default value
  T getOrElse(T defaultValue) => data ?? defaultValue;
  
  /// Transform the data if present
  Result<R> map<R>(R Function(T data) mapper) {
    if (isSuccess) return Result.success(mapper(data!));
    if (isLoading) return Result.loading();
    if (isError) return Result.error(error!);
    return Result<R>.initial();
  }
  
  /// Transform the result to another result type
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    if (isSuccess) return mapper(data!);
    if (isLoading) return Result.loading();
    if (isError) return Result.error(error!);
    return Result<R>.initial();
  }

  R when<R>({
    required R Function() initial,
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) error,
  }) {
    if (isInitial) return initial();
    if (isLoading) return loading();
    if (isSuccess) return success(data!);
    return error(this.error!);
  }

  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? initial,
    R Function()? loading,
    R Function(T data)? success,
    R Function(String message)? error,
  }) {
    if (isInitial && initial != null) return initial();
    if (isLoading && loading != null) return loading();
    if (isSuccess && success != null) return success(data!);
    if (isError && error != null) return error(this.error!);
    return orElse();
  }

  Result<T> copyWith({
    T? data,
    String? error,
    bool? isLoading,
  }) {
    return Result._(
      data: data ?? this.data,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }
  
  @override
  String toString() =>
      'Result{data: $data, error: $error, isLoading: $isLoading}';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Result<T> &&
          other.data == data &&
          other.error == error &&
          other.isLoading == isLoading;

  @override
  int get hashCode => Object.hash(data, error, isLoading);
}