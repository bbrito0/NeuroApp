class ApiResponse<T> {
  final T? data;
  final String? error;
  final int statusCode;
  final bool isSuccess;

  ApiResponse({
    this.data,
    this.error,
    required this.statusCode,
    required this.isSuccess,
  });

  factory ApiResponse.success(T data, int statusCode) {
    return ApiResponse(
      data: data,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  factory ApiResponse.error(String error, int statusCode) {
    return ApiResponse(
      error: error,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  @override
  String toString() {
    return 'ApiResponse{isSuccess: $isSuccess, statusCode: $statusCode, error: $error}';
  }
} 