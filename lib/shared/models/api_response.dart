class ApiResponse<T> {
  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.statusCode,
    this.headers,
  });
  final bool success;
  final T? data;
  final String? message;
  final int? statusCode;
  final Map<String, String>? headers;
}
