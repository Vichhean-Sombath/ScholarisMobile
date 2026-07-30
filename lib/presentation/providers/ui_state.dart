sealed class UiState<T> {
  const UiState._();

  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(String message) error,
  }) {
    return switch (this) {
      UiLoading<T>() => loading(),
      UiSuccess<T>(:final data) => success(data),
      UiError<T>(:final message) => error(message),
    };
  }
}

class UiLoading<T> extends UiState<T> {
  const UiLoading() : super._();
}

class UiSuccess<T> extends UiState<T> {
  const UiSuccess(this.data) : super._();

  final T data;
}

class UiError<T> extends UiState<T> {
  const UiError(this.message) : super._();

  final String message;
}
