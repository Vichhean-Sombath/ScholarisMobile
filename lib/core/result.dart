import 'errors.dart';

sealed class Result<T> {
  const Result._();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(AppException error) = Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success(data),
      Failure<T>(:final error) => failure(error),
    };
  }

  R? whenOrNull<R>({
    R? Function(T data)? success,
    R? Function(AppException error)? failure,
  }) {
    return switch (this) {
      Success<T>(:final data) => success?.call(data),
      Failure<T>(:final error) => failure?.call(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data) : super._();

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error) : super._();

  final AppException error;
}
