class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic response;

  ApiException({
    required this.message,
    this.statusCode,
    this.response,
  });

  @override
  String toString() => message;
}
