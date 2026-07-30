class ApiResponse<T> {
  const ApiResponse({required this.message, required this.data});

  final String message;
  final T data;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    return ApiResponse(
      message: json['message'] as String? ?? '',
      data: fromJsonT(json['data']),
    );
  }
}
